import 'package:flutter/material.dart';


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackWarning(
    {required String text,
    required ScaffoldMessengerState scaffoldMessengerKey,
    required Color? cor}) {
  final snack = SnackBar(
    content: Text(text, textAlign: TextAlign.center),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5))),
    elevation: 8,
    duration: Duration(seconds: 5),
    backgroundColor: cor,
  );

  if (scaffoldMessengerKey != null) {
    scaffoldMessengerKey.hideCurrentSnackBar();
    return scaffoldMessengerKey.showSnackBar(snack);
  }
  return scaffoldMessengerKey.showSnackBar(snack);
}

