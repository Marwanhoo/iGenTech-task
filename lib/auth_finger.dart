import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igentech_task/my_home_page.dart';
import 'package:local_auth/local_auth.dart';

class AuthFinger extends StatefulWidget {
  const AuthFinger({super.key});

  @override
  State<AuthFinger> createState() => _AuthFingerState();
}

class _AuthFingerState extends State<AuthFinger> {
  late final LocalAuthentication myAuthentication;
  bool authState = false;

  @override
  void initState() {
    super.initState();
    myAuthentication = LocalAuthentication();
    myAuthentication.isDeviceSupported().then((bool myAuth) {
      setState(() {
        authState = myAuth;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Container(

              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () async {
                  try {
                    bool isAuthenticate = await myAuthentication.authenticate(
                        localizedReason: "local authentication",
                        options: const AuthenticationOptions(
                          stickyAuth: true,
                          // IF you have choose biometric only to true it not show other option to authenticate
                          biometricOnly: true,
                        )
                    );
                    if(isAuthenticate){
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MyHomePage()),
                            (route) => false,
                      );
                    }else{
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authentica false")));
                    }
                  } on PlatformException catch (e) {
                    print(e.toString());
                  }
                  if(!mounted){
                    return;
                  }
                },
                icon: const Icon(Icons.fingerprint,size: 100,color: Colors.white,),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const FlutterLogo(),
          Text("Authentication true",style: Theme.of(context).textTheme.headlineLarge),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_igentech_task/my_home_page.dart';
// import 'package:local_auth/local_auth.dart';
//
// class AuthFinger extends StatefulWidget {
//   const AuthFinger({super.key});
//
//   @override
//   State<AuthFinger> createState() => _AuthFingerState();
// }
//
// class _AuthFingerState extends State<AuthFinger> {
//   late final LocalAuthentication myAuthentication;
//   bool authState = false;
//   List<BiometricType> availableBiometrics = [];
//
//   @override
//   void initState() {
//     super.initState();
//     myAuthentication = LocalAuthentication();
//     checkBiometricsSupport();
//   }
//
//   Future<void> checkBiometricsSupport() async {
//     try {
//       bool isSupported = await myAuthentication.isDeviceSupported();
//       if (isSupported) {
//         availableBiometrics = await myAuthentication.getAvailableBiometrics();
//       }
//       setState(() {
//         authState = isSupported;
//       });
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> authenticate(BiometricType type) async {
//     String localizedReason = type == BiometricType.face
//         ? 'Please authenticate using face recognition'
//         : 'Please authenticate using fingerprint';
//
//     try {
//       bool isAuthenticate = await myAuthentication.authenticate(
//         localizedReason: localizedReason,
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//       if (isAuthenticate) {
//         // Navigate to home page on successful authentication
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (_) => const MyHomePage()),
//               (route) => false,
//         );
//       } else {
//         // If authentication fails
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Authentication failed")),
//         );
//       }
//     } on PlatformException catch (e) {
//       print(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Biometric Authentication")),
//       body: Center(
//         child: Column(
//           children: [
//               Column(
//                 children: [
//                   const Text("Face recognition is available on this device"),
//                   const SizedBox(height: 10),
//                   ElevatedButton.icon(
//                     onPressed: () => authenticate(BiometricType.face),
//                     icon: const Icon(Icons.face, size: 50),
//                     label: const Text("Use Face Recognition"),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 20),
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: [
//                   const SizedBox(height: 30),
//                   const Text("Fingerprint is available on this device"),
//                   const SizedBox(height: 10),
//                   ElevatedButton.icon(
//                     onPressed: () => authenticate(BiometricType.fingerprint),
//                     icon: const Icon(Icons.fingerprint, size: 50),
//                     label: const Text("Use Fingerprint"),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 20),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_igentech_task/my_home_page.dart';
// import 'package:local_auth/local_auth.dart';
//
// class AuthFace extends StatefulWidget {
//   const AuthFace({super.key});
//
//   @override
//   State<AuthFace> createState() => _AuthFaceState();
// }
//
// class _AuthFaceState extends State<AuthFace> {
//   late final LocalAuthentication myAuthentication;
//   bool authState = false;
//   bool supportsFace = false;
//
//   @override
//   void initState() {
//     super.initState();
//     myAuthentication = LocalAuthentication();
//
//     // Check if face recognition is supported
//     checkForFaceRecognition();
//   }
//
//   Future<void> checkForFaceRecognition() async {
//     try {
//       bool isDeviceSupported = await myAuthentication.isDeviceSupported();
//       List<BiometricType> availableBiometrics = await myAuthentication.getAvailableBiometrics();
//
//       // Check if face recognition is available
//       setState(() {
//         authState = isDeviceSupported;
//         supportsFace = availableBiometrics.contains(BiometricType.face);
//       });
//     } on PlatformException catch (e) {
//       print(e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Center(
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 onPressed: () async {
//                   if (supportsFace) {
//                     try {
//                       bool isAuthenticate = await myAuthentication.authenticate(
//                         localizedReason: "Please authenticate with Face Recognition",
//                         options: const AuthenticationOptions(
//                           stickyAuth: true,
//                           biometricOnly: true, // Only use biometrics (face/fingerprint)
//                         ),
//                       );
//                       if (isAuthenticate) {
//                         Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(builder: (_) => const MyHomePage()),
//                               (route) => false,
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Authentication failed")),
//                         );
//                       }
//                     } on PlatformException catch (e) {
//                       print(e.toString());
//                     }
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Face recognition not supported on this device")),
//                     );
//                   }
//
//                   if (!mounted) return;
//                 },
//                 icon: const Icon(Icons.face, size: 100, color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const FlutterLogo(),
//           Text("Authentication successful", style: Theme.of(context).textTheme.headlineLarge),
//         ],
//       ),
//     );
//   }
// }
