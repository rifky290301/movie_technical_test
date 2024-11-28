import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/helper/helper.dart';

// App notifier for Lang, Theme, ...
class AppNotifierService extends ChangeNotifier {
  late bool darkTheme;

  AppNotifierService() {
    _initialise();
  }

  Future _initialise() async {
    darkTheme = Helper.isDarkTheme;

    notifyListeners();
  }

  void updateThemeTitle(bool newDarkTheme) {
    darkTheme = newDarkTheme;
    if (Helper.isDarkTheme) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    notifyListeners();
  }
}
