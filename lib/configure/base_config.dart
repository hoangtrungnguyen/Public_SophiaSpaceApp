//https://stacksecrets.com/flutter/environment-configuration-in-flutter-app
abstract class BaseConfig {
  String _apiHost = '';
  bool _useHttps = true;
  bool _trackEvents = true;
  bool _reportErrors = true;

  String get apiHost;
  bool get useHttps;
  bool get trackEvents;
  bool get reportErrors;
}
