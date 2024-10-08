import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igentech_task/views/view/personal_form_screen.dart';
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
                color: Colors.purple,
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
                        MaterialPageRoute(builder: (_) => const PersonalFormScreen()),
                            (route) => false,
                      );
                    }else{
                    }
                  } on PlatformException {}
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