import 'package:flutter/material.dart';
import 'package:flutter_igentech_task/core/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';


String translateText({
  required BuildContext context,
  required String textJson,
}) =>
    AppLocalizations.of(context)!.translate(
      textJson,
    );



SnackBar buildSnackBar(String text) {
  return  SnackBar(
    content: Text(text),
  );
}
