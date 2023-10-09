final class AppException implements Exception {
  AppException(this._message);
  final String _message;

  String get message {
    final firstLetter = _message.substring(0, 1).toUpperCase();

    return '$firstLetter${_message.substring(1)}';
  }
}
