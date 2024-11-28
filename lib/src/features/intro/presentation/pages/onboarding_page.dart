import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_technical_test/main.dart';
import 'package:movie_technical_test/src/core/helper/ui_theme_extention.dart';
import 'package:movie_technical_test/src/core/router/app_page.dart';
import 'package:movie_technical_test/src/core/router/app_routes.dart';
import 'package:movie_technical_test/src/core/styles/app_gradients.dart';

import '../../../../core/utils/constant/app_constants.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Stack(
          // fit: StackFit.passthrough,
          children: [
            Image.asset(
              '$assets/images/endgame.jpg',
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  gradient: AppGradients.backgroundText(),
                ),
              ),
            ),
            Positioned(
                bottom: 300,
                right: 0,
                left: 0,
                // alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  '$assets/logo/logo.svg',
                  width: 250,
                )),
            Positioned(
              bottom: 40,
              right: 0,
              left: 0,
              child: Text(
                'All your favourite\n MARVEL Movies & Series\n at one place',
                style: context.regular.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30).w,
          child: CustomButton(
            onPressed: () {
              context.go(AppRoute.home);
            },
            text: 'Selanjutnya',
          ),
        ),
      ]),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Tombol memanjang penuh
      height: 50, // Tinggi tombol
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Warna latar belakang merah
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sudut kotak (tidak membulat)
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, // Warna teks putih
            fontSize: 16, // Ukuran font
            fontWeight: FontWeight.bold, // Gaya font tebal
          ),
        ),
      ),
    );
  }
}
