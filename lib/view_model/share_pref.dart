import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sophia_hub/constant/share_pref.dart';
import 'package:sophia_hub/model/exception/pin_exception.dart';
import 'package:sophia_hub/model/result_container.dart';
import 'package:sophia_hub/view_model/base_view_model.dart';

class SharedPref extends BaseViewModel {
  late MaterialColor materialColor;
  late SharedPreferences _sharedPref;
  late bool _isLockActivate = false;

  SharedPreferences get sharePref => _sharedPref;

  bool get isLockActivate => _isLockActivate;

  Future<bool> updateIsLockActive({bool? value}) async {
    try {
      if (value == null) {
        await _sharedPref.setBool(SharePrefKeys.lockActivate, !_isLockActivate);
        _isLockActivate = !_isLockActivate;
        if (!_isLockActivate) {
          await _sharedPref.setString(SharePrefKeys.pinCode, '');
        }
      } else {
        await _sharedPref.setBool(SharePrefKeys.lockActivate, value);
        _isLockActivate = value;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  //Call before runApp method
  Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
    int themeColorKey =
        _sharedPref.getInt(SharePrefKeys.themeColor) ?? Colors.indigo.value;
    this.materialColor = getThemeColor(themeColorKey);
    this._isLockActivate =
        _sharedPref.getBool(SharePrefKeys.lockActivate) ?? false;
  }

  MaterialColor getThemeColor(int colorKey) =>
      Colors.primaries.firstWhere((element) => element.value == colorKey);

  Future<void> setColor(MaterialColor color) async {
    this.materialColor = color;
    try {
      await _sharedPref.setInt(SharePrefKeys.themeColor, color.value);
    } catch (e) {} finally {
      notifyListeners();
    }
  }

  Future<void> setPinCode(String pincode) async {
    await _sharedPref.setString(SharePrefKeys.pinCode, pincode);
  }

  Future<bool> authPinCode(String pinCode) =>
      setAppState(() async {
        try {
          if(sharePref.getString(SharePrefKeys.pinCode) == pinCode){
            return Result(data: "OK");
          }
          throw PinException("Mã pin không đúng");
        } on Exception catch (e) {
          return Result(err: e);
        }
      });
}
