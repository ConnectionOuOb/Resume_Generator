class TextTranslation {
  LocalText get resumeGenerator => LocalText(en: "Resume Generator", zh: "履歷產生器");
}

class LocalText {
  String en;
  String zh;

  LocalText({
    required this.en,
    required this.zh,
  });
}
