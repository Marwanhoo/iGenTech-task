import 'package:bloc/bloc.dart';
import 'package:flutter_igentech_task/core/localization/lang_enum.dart';
import 'package:flutter_igentech_task/core/utils/app_helper.dart';
import 'package:flutter_igentech_task/cubit/lang/app_lang_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLangCubit extends Cubit<AppLangState> {
  AppLangCubit(this.sharedPreferences) : super(AppLangInitial());
  final SharedPreferences sharedPreferences;

  void changeLanguage(LanguageEnums langEnum) {
    switch (langEnum) {
      case LanguageEnums.initialLanguage:
        if (sharedPreferences!.getString("lang") != null) {
          if (sharedPreferences!.getString("lang") == "ar") {
            emit(AppChangeLanguageState(langCode: "ar"));
          } else {
            emit(AppChangeLanguageState(langCode: "en"));
          }
        }
        break;
      case LanguageEnums.arabicLanguage:
        sharedPreferences!.setString("lang", "ar");
        emit(AppChangeLanguageState(langCode: "ar"));
        break;
      case LanguageEnums.englishLanguage:
        sharedPreferences!.setString("lang", "en");
        emit(AppChangeLanguageState(langCode: "en"));
        break;
    }
  }
}



/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_lang_state.dart';
import 'lang_enum.dart';

class AppLangCubit extends Cubit<AppLangState> {
  final SharedPreferences sharedPreferences;

  AppLangCubit(this.sharedPreferences) : super(AppLangInitial());

  void changeLanguage(LanguageEnums langEnum) {
    switch (langEnum) {
      case LanguageEnums.initialLanguage:
        final storedLang = sharedPreferences.getString("lang");
        if (storedLang != null) {
          if (storedLang == "ar") {
            emit(AppChangeLanguageState(langCode: "ar"));
          } else {
            emit(AppChangeLanguageState(langCode: "en"));
          }
        }
        break;
      case LanguageEnums.arabicLanguage:
        sharedPreferences.setString("lang", "ar");
        emit(AppChangeLanguageState(langCode: "ar"));
        break;
      case LanguageEnums.englishLanguage:
        sharedPreferences.setString("lang", "en");
        emit(AppChangeLanguageState(langCode: "en"));
        break;
    }
  }
}

 */