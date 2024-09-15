
import 'package:flutter/material.dart';

@immutable
abstract class ThemeState {}

final class ThemeInitial extends ThemeState {}
class AppChangeModeState extends ThemeState {
  final ThemeMode themeMode;

  AppChangeModeState(this.themeMode);
}