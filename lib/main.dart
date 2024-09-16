import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/auth_finger.dart';
import 'package:flutter_igentech_task/core/localization/app_localization_config.dart';
import 'package:flutter_igentech_task/core/localization/lang_enum.dart';
import 'package:flutter_igentech_task/core/theme/dark_theme.dart';
import 'package:flutter_igentech_task/core/theme/light_theme.dart';
import 'package:flutter_igentech_task/core/utils/app_helper.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_cubit.dart';
import 'package:flutter_igentech_task/cubit/dark/theme_cubit.dart';
import 'package:flutter_igentech_task/cubit/dark/theme_state.dart';
import 'package:flutter_igentech_task/cubit/lang/app_lang_cubit.dart';
import 'package:flutter_igentech_task/cubit/lang/app_lang_state.dart';
import 'package:flutter_igentech_task/home_page.dart';
import 'package:flutter_igentech_task/location_screen.dart';
import 'package:flutter_igentech_task/my_bloc_observer.dart';
import 'package:flutter_igentech_task/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart' as di;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Bloc.observer = MyBlocObserver();
  //sharedPreferences = await SharedPreferences.getInstance();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit(),
        ),
        // BlocProvider(
        //     create: (BuildContext context) =>
        //         AppLangCubit()..changeLanguage(LanguageEnums.initialLanguage)),
        BlocProvider<AppLangCubit>(
          create: (context) => di.sl<AppLangCubit>(),
        ),
        // BlocProvider(create: (context) => ThemeCubit()..loadThemeMode()),
        BlocProvider<ThemeCubit>(
          create: (context) => di.sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<AppLangCubit, AppLangState>(
        builder: (context, state) {
          final Locale locale = state is AppChangeLanguageState
              ? Locale(state.langCode)
              : const Locale('en', 'US');
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'IGentech Task',
                locale: locale,
                supportedLocales: AppLocalizationsConfig.supportedLocales,
                localizationsDelegates:
                    AppLocalizationsConfig.localizationsDelegates(),
                localeResolutionCallback:
                    AppLocalizationsConfig.localeResolutionCallback,
                theme: lightTheme(),
                darkTheme: darkTheme(),
                themeMode: (state is AppChangeModeState)
                    ? state.themeMode
                    : ThemeMode.light,
                home:   HomePage(),
              );
            },
          );
        },
      ),
    );
  }
}
