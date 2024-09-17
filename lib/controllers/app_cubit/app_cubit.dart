import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igentech_task/controllers/app_cubit/app_state.dart';
import 'package:flutter_igentech_task/models/database/sqldb.dart';
import 'package:flutter_igentech_task/models/model/profile_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';


class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  String? selectedGender;
  DateTime? selectedDate;


  // Method to change gender
  void changeGender(String gender) {
    selectedGender = gender;
    emit(GenderChangedState(gender));
  }

  // Method to change birthdate
  void changeBirthdate(DateTime date) {
    selectedDate = date;
    emit(DateChangedState(date));
  }

  Future<void> selectDate(BuildContext context, AppCubit cubit) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: cubit.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      cubit.changeBirthdate(picked);
    }
  }



  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(ChangePasswordVisibilityState());
  }






  SqlDb sqlDb = SqlDb();
  //List<Map> profileData = [];
  List<ProfileModel> profileData = [];
  Future<void> loadProfileData() async {
    emit(LoadingState()); // Emit loading state initially
    try {
      //List<Map> response = await sqlDb.read("notes");
      List<Map<String, dynamic>> response = await sqlDb.read("notes");
      if (response.isNotEmpty) {
        //profileData = response;
        profileData = response.map((map) => ProfileModel.fromMap(map)).toList();
        emit(ProfileLoadedState(profileData));
      } else {
        emit(EmptyProfileState()); // Emit if data is empty
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString())); // Emit error state
    }
  }




  Future<void> submitForm({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
      String date = "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}";
      try {
        emit(FormSubmittingState());

        int response = await sqlDb.insert("notes", {
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "gender": selectedGender,
          "date": date,
        });

        if (response > 0) {
          emit(FormSubmittedState());
        }
      } catch (e) {
        emit(FormErrorState("Failed to submit form: ${e.toString()}"));
      }

  }




/// Location
  Future<void> openInGoogleMaps(currentPosition) async {
    if (currentPosition != null) {
      final latitude = currentPosition!.latitude;
      final longitude = currentPosition!.longitude;
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else {
        throw 'Could not open Google Maps';
      }
    }
  }



  // Function to show dialog when location services are disabled
  void showLocationServiceDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services to proceed.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () async {
              Navigator.of(context).pop();
              // Open location settings (platform-specific)
              try {
                bool opened = await Geolocator.openLocationSettings();
                if (!opened) {
                  throw 'Could not open location settings';
                }
              } catch (e) {
                debugPrint('Error: $e');
                // Show error message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not open location settings.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }


}
