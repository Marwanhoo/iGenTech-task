import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/core/localization/lang_enum.dart';
import 'package:flutter_igentech_task/core/utils/app_helper.dart';
import 'package:flutter_igentech_task/core/widget/custom_text_field.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_cubit.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_state.dart';
import 'package:flutter_igentech_task/cubit/dark/theme_cubit.dart';
import 'package:flutter_igentech_task/cubit/dark/theme_state.dart';
import 'package:flutter_igentech_task/cubit/lang/app_lang_cubit.dart';
import 'package:flutter_igentech_task/cubit/lang/app_lang_state.dart';
import 'package:flutter_igentech_task/location_screen.dart';
import 'package:flutter_igentech_task/profile_screen.dart';
import 'package:flutter_igentech_task/sqldb.dart';

class PersonalFormScreen extends StatelessWidget {
  const PersonalFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = BlocProvider.of(context);
    final AppLangCubit appLangCubit = BlocProvider.of<AppLangCubit>(context);
    AppLangState appLangState = appLangCubit.state;
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    List<String> genderList = [
      (translateText(context: context, textJson: "male")),
      (translateText(context: context, textJson: "female")),
    ];

    SqlDb sqlDb = SqlDb();

    return Scaffold(
      appBar: AppBar(
        title: Text(translateText(context: context, textJson: "personal")),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final themeCubit = BlocProvider.of<ThemeCubit>(context);
              return CircleAvatar(
                child: IconButton(
                  onPressed: () {
                    themeCubit.changeAppMode();
                  },
                  icon: Icon(themeCubit.themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          const Text("|"),
          const SizedBox(width: 10),
          Text(appLangState is AppChangeLanguageState &&
                  appLangState.langCode == "ar"
              ? "Ar"
              : "En"),
          Switch(
            value: appLangState is AppChangeLanguageState &&
                appLangState.langCode == "ar",
            onChanged: (bool value) {
              if (value) {
                appLangCubit.changeLanguage(LanguageEnums.arabicLanguage);
              } else {
                appLangCubit.changeLanguage(LanguageEnums.englishLanguage);
              }
            },
          ),
          Text(appLangState is AppChangeLanguageState && appLangState.langCode == "ar" ? "En" : "Ar"),

          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: nameController,
                  hintText:
                      translateText(context: context, textJson: "firstName"),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: emailController,
                  hintText: translateText(
                    context: context,
                    textJson: "email",
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return CustomTextFormField(
                      controller: passwordController,
                      hintText:
                          translateText(context: context, textJson: "password"),
                      suffixIcon: IconButton(
                        onPressed: () {
                          BlocProvider.of<AppCubit>(context)
                              .changePasswordVisibility();
                        },
                        icon: Icon(
                          BlocProvider.of<AppCubit>(context).suffix,
                        ),
                      ),
                      obscureText:
                          BlocProvider.of<AppCubit>(context).isPassword,
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    final cubit = context.read<AppCubit>();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translateText(
                              context: context, textJson: "selectGender"),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: cubit.selectedGender,
                          hint: Text(translateText(
                              context: context, textJson: "chooseGender")),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              cubit.changeGender(newValue);
                            }
                          },
                          items: genderList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    final cubit = context.read<AppCubit>();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translateText(
                              context: context, textJson: "selectBirthdate"),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                cubit.selectedDate == null
                                    ? translateText(
                                        context: context,
                                        textJson: "noDateSelected")
                                    : '${translateText(context: context, textJson: "selectedDate")}: ${cubit.selectedDate!.day}/${cubit.selectedDate!.month}/${cubit.selectedDate!.year}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  appCubit.selectDate(context, cubit),
                              child: Text(translateText(
                                  context: context, textJson: "pickDate")),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                const LocationScreen(),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async{
                    if (formKey.currentState!.validate()) {
                      int response = await sqlDb.insert("notes", {
                        "name" : nameController.text,
                        "email" : emailController.text,
                        "password" : passwordController.text,
                      });

                      if(response > 0){

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ProfileScreen()));


                      }






                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please Form Data")));
                    }
                  },
                  child:
                      Text(translateText(context: context, textJson: "save")),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
