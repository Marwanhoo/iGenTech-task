// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   // Dropdown related variables
//   String? selectedGender;
//   List<String> genderList = ['Male', 'Female', 'Other'];
//
//   // Date Picker related variables
//   DateTime? selectedDate;
//
//   // Function to display the date picker dialog
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dropdown and Date Picker Example'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             // Dropdown Menu for Gender
//             Text(
//               'Select Gender',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             DropdownButton<String>(
//               isExpanded: true,
//               value: selectedGender,
//               hint: Text('Choose gender'),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedGender = newValue;
//                 });
//               },
//               items: genderList.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//
//             // Date Picker for Birthdate
//             Text(
//               'Select Birthdate',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Text(
//                     selectedDate == null
//                         ? 'No date selected'
//                         : 'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => _selectDate(context),
//                   child: Text('Pick Date'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 40),
//
//             // Show selected values (optional)
//             Text(
//               'Selected Gender: ${selectedGender ?? 'Not selected'}',
//               style: TextStyle(fontSize: 16),
//             ),
//             Text(
//               'Selected Birthdate: ${selectedDate == null ? 'Not selected' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'}',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_cubit.dart';
import 'package:flutter_igentech_task/cubit/app_cubit/app_state.dart';

class HomePage extends StatelessWidget {
  final List<String> genderList = ['Male', 'Female', 'Other'];

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
        title: Text('Cubit Dropdown & DatePicker Example'),
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
                    Text(
                      'Select Gender',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: cubit.selectedGender,
                      hint: Text('Choose gender'),
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
            SizedBox(height: 20),

            // Date picker for birthdate
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final cubit = context.read<AppCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, cubit),
                          child: Text('Pick Date'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 40),

            // Display selected gender and date
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                final cubit = context.read<AppCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Gender: ${cubit.selectedGender ?? 'Not selected'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Selected Birthdate: ${cubit.selectedDate == null ? 'Not selected' : '${cubit.selectedDate!.day}/${cubit.selectedDate!.month}/${cubit.selectedDate!.year}'}',
                      style: TextStyle(fontSize: 16),
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