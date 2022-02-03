import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sophia_hub/provider/share_pref.dart';

main() {
  late SharedPref sharePref;
  setUpAll(() async {
    Map<String, Object> values = <String, Object>{};
    SharedPreferences.setMockInitialValues(values);
    sharePref = SharedPref();
    await sharePref.init();
  });

  test("initial", () {
    expect(sharePref.materialColor.value, Colors.indigo.value);
  });

  test("set Color", () async{
    MaterialColor color = Colors.deepOrange;
    await sharePref.setColor(color);
    expect(sharePref.getThemeColor(color.value).value, Colors.deepOrange.value );

  });
}