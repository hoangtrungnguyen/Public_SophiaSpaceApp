import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

abstract class App with ChangeNotifier {
  final isLoadingPublisher = BehaviorSubject<bool>();

  Future<ConnectivityResult?> checkingNetwork() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult;
    } catch (e) {
      return null;
    }
  }
}
