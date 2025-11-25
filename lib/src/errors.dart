class AppFailure implements Exception {
  final String code;
  final String message;
  AppFailure(this.code, this.message);
  @override
  String toString() => '$code: $message';
}