import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_technical_test/src/core/helper/ui_theme_extention.dart';
import 'package:movie_technical_test/src/core/utils/constant/app_constants.dart';

class AppError extends StatelessWidget {
  final void Function()? onPressed;
  const AppError({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('$assets/undraw/error.svg', height: 150),
            const SizedBox(height: 12),
            IconButton(
              onPressed: onPressed,
              iconSize: 36,
              icon: const Icon(
                Icons.replay_outlined,
                color: Colors.white,
              ),
            ),
            Text(
              'Muat Ulang',
              style: context.label.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
