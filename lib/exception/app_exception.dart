class AppException implements Exception {
  static final levelError = 900;
  static final levelWarning = 500;
  final String msg;
  final int level;
  final String? codeError;

  const AppException(this.level, this.msg, {this.codeError});
  String toString() => msg;
}
