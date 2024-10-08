import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/controllers/app_cubit/app_cubit.dart';
import 'package:flutter_igentech_task/controllers/dark/theme_cubit.dart';
import 'package:flutter_igentech_task/controllers/dark/theme_state.dart';
import 'package:flutter_igentech_task/controllers/lang/app_lang_cubit.dart';
import 'package:flutter_igentech_task/controllers/lang/app_lang_state.dart';
import 'package:flutter_igentech_task/core/localization/app_localization_config.dart';
import 'package:flutter_igentech_task/core/theme/dark_theme.dart';
import 'package:flutter_igentech_task/core/theme/light_theme.dart';
import 'package:flutter_igentech_task/views/view/auth_finger.dart';
import 'core/utils/injection_container.dart' as di;
import 'core/utils/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit(),
        ),
        BlocProvider<AppLangCubit>(
          create: (context) => di.sl<AppLangCubit>(),
        ),
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
                title: AppStrings.appName,
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
                home: const AuthFinger(),
              );
            },
          );
        },
      ),
    );
  }
}

