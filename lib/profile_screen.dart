import 'package:flutter/material.dart';
import 'package:flutter_igentech_task/core/utils/app_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText(context: context, textJson: "profile")),
      ),
    );
  }
}
