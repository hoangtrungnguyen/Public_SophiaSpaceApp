import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String apiUrl;

  AppConfig({required this.apiUrl});

  static Future<AppConfig> forEnvironment(String? env) async {
    // set default to dev if nothing was passed
    env = (env ?? 'dev').toLowerCase();

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    return AppConfig(apiUrl: json['apiUrl']);
  }
}
