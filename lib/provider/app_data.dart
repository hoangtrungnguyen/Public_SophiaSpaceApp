import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sophia_hub/constant/app_connection_state.dart';
import 'package:sophia_hub/model/result_container.dart';

abstract class App<T> {
  T? data;
  final appConnectionState = BehaviorSubject<ConnectionState>();
  Exception? error;

  Future<bool> setAppState(Future<Result<T>> Function() body) async {
    appConnectionState.add(ConnectionState.waiting);
    Result<T> result = await body();
    appConnectionState.add(ConnectionState.done);
    if (result.isHasErr) {
      error = result.error;
      return false;
    } else {
      error = null;
      return true;
    }
  }
}
