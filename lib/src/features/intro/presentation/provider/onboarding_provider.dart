import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  List<({String title, String image})> textOnboarding = [
    (title: 'All your favourite\nMARVEL Movies & Series\nat one place', image: 'endgame'),
    (title: 'Watch Online\nor\nDownload Offline', image: 'deadpool'),
    (title: 'Create profiles for\ndiffrent members &\nget personalised\nrecommendations', image: 'doctor'),
    (title: 'Plans according to your\nneeds at affordable\nprices', image: 'ironman'),
    (title: 'Lets Get Started !!!', image: 'thor'),
  ];

  int activeStep = 0;

  updateNext() {
    if (activeStep == 5) return;
    activeStep++;
    notifyListeners();
  }

  updateBack() {
    if (activeStep == 0) return;
    activeStep--;
    notifyListeners();
  }
}
