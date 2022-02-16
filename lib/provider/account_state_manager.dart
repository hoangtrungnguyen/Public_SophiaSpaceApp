import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:sophia_hub/model/account.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/provider/app_data.dart';
import 'package:sophia_hub/repository/auth_repository.dart';

class AccountStateManager extends App with ChangeNotifier {
  Account account = Account();

  late AuthRepository _repository;

  AccountStateManager({AuthRepository? repository}) {
    _repository = repository ?? AuthRepository();
  }

  Future<bool> login(String email, pwd) async => setAppState(() async {
        Result<User> result = await _repository.login(email, pwd);
        return result;
      });

  Future<bool> register(String email, pwd, displayName) async => setAppState(() async {
        Result<User> result = await _repository.register(email, pwd,displayName);
        return result;
      });

  Future<bool> logOut() async =>
      setAppState(() async => await _repository.signOut());

  void refresh() {
    //TODO refresh on device user data
    notifyListeners();
  }


  Stream<User?> userChanges() => _repository.auth.authStateChanges();

  Future updateAvatar(String path, uid) async => setAppState(() async {
        return await _repository.updateAvatar(path, uid);
      });

  Future updateName(String name) async => setAppState(
          () async => await _repository.updateName(name));

  resetPwd(String email) {
    //TODO reset pwd
  }
}
