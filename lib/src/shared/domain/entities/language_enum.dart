enum LanguageEnum {
  id, // Indonesia
  en, // English
}

extension LanguageEnumExtension on LanguageEnum {
  String get localHeader {
    switch (this) {
      case LanguageEnum.id:
        return "id_ID";

      case LanguageEnum.en:
        return "en_US";

      default:
        return "en_US";
    }
  }
}
