/***
 * Class chứa dữ liệu
 ***/
class Result<T> {
  T _data;
  Exception _error;

  Result({T data, Exception err}){
    _data = data;
    _error = err;
  }

  bool get isHasData {
    if(_error != null){
      throw Exception();
    }
    return data != null;
  }

  set(data) => _data = data;

  bool get isHasErr {
    if(_data != null){
      throw Exception();
    }
    return error != null;
  }

  get data => _data;

  get error => _error;
}
