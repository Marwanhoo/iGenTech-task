import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_cubit.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_state.dart';

class HomePage extends StatelessWidget {
  final List<String> genderList = const['Male', 'Female', 'Other'];

  const HomePage({super.key});

  // Method to open the date picker dialog
  Future<void> _selectDate(BuildContext context, AppCubit cubit) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: cubit.selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      cubit.changeBirthdate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit Dropdown & DatePicker Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Dropdown menu for gender selection
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final cubit = context.read<AppCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Gender',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: cubit.selectedGender,
                      hint: const Text('Choose gender'),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          cubit.changeGender(newValue);
                        }
                      },
                      items: genderList.map<DropdownMenuItem<String>>((String value) {
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
            const SizedBox(height: 20),

            // Date picker for birthdate
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final cubit = context.read<AppCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Birthdate',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            cubit.selectedDate == null
                                ? 'No date selected'
                                : 'Selected Date: ${cubit.selectedDate!.day}/${cubit.selectedDate!.month}/${cubit.selectedDate!.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, cubit),
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),

            // Display selected gender and date
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final cubit = context.read<AppCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Gender: ${cubit.selectedGender ?? 'Not selected'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Selected Birthdate: ${cubit.selectedDate == null ? 'Not selected' : '${cubit.selectedDate!.day}/${cubit.selectedDate!.month}/${cubit.selectedDate!.year}'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}