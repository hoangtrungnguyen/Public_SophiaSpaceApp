///
/// Class chứa kết quả
///
/// Main purpose of **assert** is testing conditions during debugging/development.

class Result<T> {
  T? _data;
  Exception? _error;

  Result({T? data, Exception? err}) {
    _data = data;
    _error = err;
  }

  bool get isHasData {
    return data != null;
  }

  set(data) => _data = data;

  bool get isHasErr {
    return error != null;
  }

  get data => _data;

  get error => _error;
}
