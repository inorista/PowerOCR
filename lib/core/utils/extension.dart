extension PlainTextExtension on String {
  String get plainText {
    return replaceAll('\n', ' ');
  }
}
