import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sophia_hub/constant/share_pref.dart';

class SharedPref extends ChangeNotifier {
  late MaterialColor materialColor;
  late SharedPreferences _sharedPref;

  SharedPreferences get sharePref => _sharedPref;

  //Call before runApp method
  Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
    int themeColorKey =
        _sharedPref.getInt(SharePrefKeys.themeColor) ?? Colors.indigo.value;
    this.materialColor = getThemeColor(themeColorKey);
  }

  MaterialColor getThemeColor(int colorKey) =>
      Colors.primaries.firstWhere((element) => element.value == colorKey);

  Future<void> setColor(MaterialColor color) async {
    this.materialColor = color;
    try {
      await _sharedPref.setInt(SharePrefKeys.themeColor, color.value);
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }
}
