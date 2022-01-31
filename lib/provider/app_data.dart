import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

abstract class App with ChangeNotifier {
  final isLoadingPublisher = BehaviorSubject<bool>() ;


  Future<ConnectivityResult> checkingNetwork()async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult;

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {

    }
  }

}
