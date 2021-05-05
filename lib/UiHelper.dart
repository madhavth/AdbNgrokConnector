import 'package:flutter/material.dart';

class UiHelper {
  static void showSnackbar(BuildContext context, {String? message})
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message?? "empty message")));
  }
}