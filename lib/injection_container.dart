import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/core/localization/lang_enum.dart';
import 'package:flutter_igentech_task/cubit/dark/theme_cubit.dart';
import 'package:flutter_igentech_task/cubit/lang/app_lang_cubit.dart';
import 'package:flutter_igentech_task/my_bloc_observer.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';


final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Register SharedPreferences instance
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register Bloc Observer
  sl.registerLazySingleton<MyBlocObserver>(() => MyBlocObserver());
  // Assign the BlocObserver to Bloc.observer
  Bloc.observer = sl<MyBlocObserver>();


  // Register Cubits
  sl.registerFactory<AppLangCubit>(() => AppLangCubit(sharedPreferences)..changeLanguage(LanguageEnums.initialLanguage));
  sl.registerFactory<ThemeCubit>(() => ThemeCubit()..loadThemeMode());
}