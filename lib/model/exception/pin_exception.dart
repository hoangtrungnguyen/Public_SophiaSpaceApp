class PinException implements Exception {
  String toString() => "PinException: '$_s'";
  final String _s;
  PinException(String message): _s = message;
}