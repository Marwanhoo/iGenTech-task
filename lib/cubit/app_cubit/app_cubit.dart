import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_state.dart';


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


  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(ChangePasswordVisibilityState());
  }

}
