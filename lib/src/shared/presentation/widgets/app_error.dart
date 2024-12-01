import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_technical_test/src/core/utils/constant/app_constants.dart';

class AppError extends StatelessWidget {
  const AppError({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SvgPicture.asset('$assets/undraw/error.svg', height: 150),
        )
      ],
    );
  }
}
