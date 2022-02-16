enum AppConnectionState {
  LOADING,
  SUCCESS,
  ERROR,
}

extension Message on AppConnectionState{
  String? getErrorMessage(Exception exception){
    if(this.name == AppConnectionState.ERROR.name){
      //TODO lọc mã lỗi ở đây
      return "Lỗi xảy ra với ${exception}";
    } else {
      return null;
    }
  }

  String? getSuccessMessage() {
    if (this.name == AppConnectionState.LOADING.name) {
      return "Thành công";
    }
    return null;
  }
}

