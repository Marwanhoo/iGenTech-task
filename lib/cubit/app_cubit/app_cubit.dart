import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_state.dart';
import 'package:flutter_igentech_task/profile_screen.dart';
import 'package:flutter_igentech_task/sqldb.dart';
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



  Future<void> openInGoogleMaps(_currentPosition) async {
    if (_currentPosition != null) {
      final latitude = _currentPosition!.latitude;
      final longitude = _currentPosition!.longitude;
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else {
        throw 'Could not open Google Maps';
      }
    }
  }



  SqlDb sqlDb = SqlDb();
  List<Map> profileData = [];
  Future<void> loadProfileData() async {
    emit(LoadingState()); // Emit loading state initially
    try {
      List<Map> response = await sqlDb.read("notes");
      if (response.isNotEmpty) {
        profileData = response;
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
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        }
      } catch (e) {
        emit(FormErrorState("Failed to submit form: ${e.toString()}"));
      }

  }


}
