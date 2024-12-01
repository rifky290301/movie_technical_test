import 'package:flutter/material.dart';
import 'package:movie_technical_test/src/core/helper/ui_theme_extention.dart';
import 'package:movie_technical_test/src/core/styles/app_colors.dart';

InputDecoration inputDecorationCustom(BuildContext context) {
  return InputDecoration(
    prefixIcon: const Icon(Icons.search_rounded),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    fillColor: Colors.transparent,
    filled: true,
    hintText: 'Search movie ...',
    hintStyle: context.body,
  );
}
