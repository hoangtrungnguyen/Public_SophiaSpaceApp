import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sophia_hub/provider/task_provider.dart';

main() async {
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group("adding ok", () {
    test("Adding tasks full fields", () {
      TaskProvider provider = TaskProvider();
      // Note note = Note()..emotionPoint = 9;
    });
  });
}
