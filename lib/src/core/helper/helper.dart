import '../../shared/data/datasources/app_shared_prefs.dart';
import '../../shared/domain/entities/language_enum.dart';
import '../utils/injections.dart';

class Helper {
  Helper._();

  /// Get and set language
  static LanguageEnum get getLang => sl<AppSharedPrefs>().getLang;
  static void setLang(LanguageEnum value) => sl<AppSharedPrefs>().setLang = value;

  /// Get and set dark mode
  static bool get isDarkTheme => sl<AppSharedPrefs>().getIsDarkTheme;
  static void setDarkTheme(bool value) => sl<AppSharedPrefs>().setDarkTheme = value;

  /// Get and set dark mode
  static bool get isHaveSeenOnboarding => sl<AppSharedPrefs>().getOnBoarding;
  static void setHaveSeenOnboarding(bool value) => sl<AppSharedPrefs>().setOnBoarding = value;

  /// Get Dio Header
  static Map<String, dynamic> getHeaders() {
    return {}..removeWhere((key, value) => value == null);
  }
}
