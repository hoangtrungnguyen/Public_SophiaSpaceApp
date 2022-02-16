
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sophia_hub/configure/firebase_config.dart';

class AppConfig {
  // final String apiUrl;
  //
  // AppConfig({required this.apiUrl});

  static Future<AppConfig> forEnvironment() async {

    if(kDebugMode){
      await dotenv.load(fileName: "env/dev.env");
      await FirebaseConfig.config();
    }

    // convert our JSON into an instance of our AppConfig class
    // return AppConfig(apiUrl: json['apiUrl']);
    return AppConfig();
  }
}
