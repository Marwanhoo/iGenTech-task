import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igentech_task/cubit/dark/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  ThemeMode themeMode = ThemeMode.light;

  void changeAppMode() async{
    themeMode =
    (themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    emit(AppChangeModeState(themeMode));
    await saveThemeMode(themeMode);
  }

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    emit(AppChangeModeState(themeMode));
  }
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
  }
}