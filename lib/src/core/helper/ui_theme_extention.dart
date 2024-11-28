import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension UIThemeExtension on BuildContext {
  TextStyle get onBoardingTitle => Theme.of(this).textTheme.headlineLarge!.copyWith(fontSize: 30.sp);
  TextStyle get regular => Theme.of(this).textTheme.headlineSmall!.copyWith(fontSize: 16.sp);
  TextStyle get body => Theme.of(this).textTheme.headlineSmall!.copyWith(fontSize: 12.sp);
  TextStyle get label => Theme.of(this).textTheme.bodyMedium!.copyWith(fontSize: 14.sp);
}
