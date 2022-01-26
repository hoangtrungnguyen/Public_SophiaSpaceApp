import 'base_config.dart';

class ProdConfig implements BaseConfig {
  String get apiHost => "example.com";

  bool get reportErrors => true;

  bool get trackEvents => true;

  bool get useHttps => true;
}