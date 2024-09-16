import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_cubit.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_state.dart';

class PersonalFormScreen extends StatelessWidget {
  const PersonalFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "";
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 10),

          BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              return TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      BlocProvider.of<AppCubit>(context)
                          .changePasswordVisibility();
                    },
                    icon: Icon(
                      BlocProvider.of<AppCubit>(context).suffix,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: BlocProvider.of<AppCubit>(context).isPassword,
              );
            },
          ),
        ],
      ),
    );
  }
}
