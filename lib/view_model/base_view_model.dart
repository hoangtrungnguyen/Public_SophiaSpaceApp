import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sophia_hub/model/result_container.dart';

abstract class BaseViewModel<T> with ChangeNotifier{
  T? data;
  ConnectionState _appConnectionState = ConnectionState.none;

  set appConnectionState(ConnectionState state){
    _appConnectionState = state;
    notifyListeners();
  }

  ConnectionState get appConnectionState => _appConnectionState;

  Exception? error;

  Future<bool> setAppState(Future<Result<T>> Function() body) async {
    appConnectionState = ConnectionState.waiting;
    Result<T> result = await body();
    appConnectionState = ConnectionState.done;
    if (result.isHasErr) {
      error = result.error;
      if(kDebugMode) {
        print(error);
      }
      return false;
    } else {
      error = null;
      return true;
    }
  }
}
