import 'package:flutter/material.dart';

part 'app_font_size.dart';
part 'app_fonts.dart';

class AppTextStyle {
  AppTextStyle._();

  static const textBold = TextStyle(fontFamily: _AppFonts.mulishBold);
  static const textSemiBold = TextStyle(fontFamily: _AppFonts.mulishSemiBold);
  static const textMedium = TextStyle(fontFamily: _AppFonts.mulishMedium);
  static const textRegular = TextStyle(fontFamily: _AppFonts.mulishRegular);
}
