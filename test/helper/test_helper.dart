// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sophia_hub/model/activity.dart';
// import 'package:sophia_hub/model/note.dart';
// import 'package:sophia_hub/provider/note_state_manager.dart';
//
// class TestHelper {
//   static Future initializeData(NotesPublisher publisher) async {
//     await Future.forEach(List<int>.generate(10, (i) => i + 1), (int e) async {
//       Note note = Note(
//           title: 'Tiêu đề $e',
//           description: "Nội dung  $e",
//           emotionPoint: Random().nextInt(10),
//           activities: List.from([
//             activities[0],
//             activities[1],
//             activities[2],
//           ]));
//       note
//         ..timeCreated =
//         DateTime.now().subtract(Duration(days: Random().nextInt(15)));
//       await publisher.addNote(note: note);
//     });
//   }
//
//   static clearUserData(NotesStateManager publisher) async {
//     // QuerySnapshot snapshots = await publisher.notesRef.get();
//     // await Future.forEach<QueryDocumentSnapshot>(snapshots.docs, (doc) async {
//     //   await doc.reference.delete();
//     // });
//     //
//     // publisher.notes = [];
//   }
//
// }
