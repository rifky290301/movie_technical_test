import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_technical_test/src/core/helper/helper.dart';
import 'package:movie_technical_test/src/core/styles/app_colors.dart';
import 'package:movie_technical_test/src/features/intro/presentation/provider/onboarding_provider.dart';
import '../../../../core/helper/ui_theme_extention.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/styles/app_gradients.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/constant/app_constants.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider(
        create: (_) => OnboardingProvider(),
        child: Consumer<OnboardingProvider>(
          builder: (context, value, child) => Column(children: [
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe ke kanan
                  value.updateNext();
                } else if (details.primaryVelocity! < 0) {
                  // Swipe ke kiri
                  value.updateBack();
                }
              },
              child: Stack(children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: Image.asset(
                    '$assets/images/${value.textOnboarding[value.activeStep].image}.jpg',
                    fit: BoxFit.cover,
                  ),
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
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 0,
                  left: 0,
                  child: Text(
                    value.textOnboarding[value.activeStep].title,
                    style: context.regular.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  left: 0,
                  child: DotCustomIndicator(
                    dotCount: value.textOnboarding.length,
                    activeStep: value.activeStep,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30).w,
              child: Row(
                children: [
                  if (value.activeStep != 0)
                    TextButton(
                      onPressed: () {
                        _slideAnimation = Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.fastOutSlowIn,
                        ));
                        _animationController.forward(from: 0.0);

                        value.updateBack();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                      ),
                    ),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        if ((value.activeStep + 1) == value.textOnboarding.length) {
                          Helper.setHaveSeenOnboarding(true);
                          context.go(AppRoute.home);
                        } else {
                          _slideAnimation = Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.fastOutSlowIn,
                          ));

                          _animationController.forward(from: 0.0);

                          value.updateNext();
                        }
                      },
                      text: 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
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

class DotCustomIndicator extends StatelessWidget {
  const DotCustomIndicator({
    super.key,
    required this.dotCount,
    required this.activeStep,
    this.color = Colors.white,
  });

  final int activeStep;
  final int dotCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dotCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
            width: (index == activeStep) ? 30 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: (index == activeStep) ? AppColors.primary : color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
