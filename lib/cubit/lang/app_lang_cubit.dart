import 'package:bloc/bloc.dart';
import 'package:flutter_igentech_task/core/localization/lang_enum.dart';
import 'package:flutter_igentech_task/core/utils/app_helper.dart';
import 'package:flutter_igentech_task/cubit/lang/app_lang_state.dart';

class AppLangCubit extends Cubit<AppLangState> {
  AppLangCubit() : super(AppLangInitial());

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
