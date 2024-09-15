abstract class AppLangState {}

class AppLangInitial extends AppLangState {}
class AppChangeLanguageState extends AppLangState{
  final String langCode;

  AppChangeLanguageState({required this.langCode});
}
