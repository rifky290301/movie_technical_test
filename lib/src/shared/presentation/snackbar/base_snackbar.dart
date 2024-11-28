import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, {required String text}) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: Colors.teal,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Dismiss',
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: () {
        //Do whatever you want
      },
    ),
    onVisible: () {
      //your code goes here
    },
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
