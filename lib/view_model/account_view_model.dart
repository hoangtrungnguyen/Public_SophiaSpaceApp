import 'package:firebase_auth/firebase_auth.dart';
import 'package:sophia_hub/model/account.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/repository/auth_repository.dart';

import 'base_view_model.dart';

class AccountViewModel extends BaseViewModel  {
  Account account = Account();

  late AuthRepository _repository;

  AccountViewModel({AuthRepository? repository}) {
    _repository = repository ?? AuthRepository();
  }

  Future<bool> login(String email, pwd) async => setAppState(() async {
        Result<User> result = await _repository.login(email, pwd);
        return result;
      });

  Future<bool> register(String email,String pwd,String displayName) async => setAppState(() async {
        Result<User> result = await _repository.register(email, pwd,displayName);
        return result;
      });

  Future<bool> logOut() async =>
      setAppState(() async {
        final res = await _repository.signOut();
        if(res.isHasData){
          this.account.clear();
        }
        return res;
      });

  void refresh() {
    //TODO refresh on device user data
    _repository.refresh();
    notifyListeners();
  }


  Stream<User?> authStateChanges() => _repository.auth.authStateChanges();
  Stream<User?> userChanges() => _repository.auth.userChanges();

  User? getCurrentUser() => _repository.auth.currentUser;

  Future<bool> updateAvatar(String path, uid) async => setAppState(() async {
        return await _repository.updateAvatar(path, uid);
      });

  Future updateName(String name) async => setAppState(
          () async => await _repository.updateName(name));

  Future<bool> resetPwd(String email) async => setAppState(() async {
    return await _repository.resetPwd(email);
  });

}
