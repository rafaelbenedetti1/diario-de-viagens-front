class AppException implements Exception {
  static const levelError = 900;
  static const levelWarning = 500;
  final String msg;
  final int level;
  final String? codeError;

  const AppException(this.level, this.msg, {this.codeError});
  String toString() => msg;
}
