import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();
  static Gradient backgroundText({AlignmentGeometry? begin, AlignmentGeometry? end}) => LinearGradient(
        colors: const [
          Colors.black, // Hitam pekat
          Colors.transparent, // Transparan
        ],
        begin: begin ?? Alignment.bottomCenter,
        end: end ?? Alignment.topCenter,
      );
}
