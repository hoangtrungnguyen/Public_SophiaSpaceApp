import 'package:cloud_firestore/cloud_firestore.dart';

class NoteException implements Exception {
  String toString() => "NoteException: '$_s'";
  final String _s;
  NoteException(String message): _s = message;
}

class NoteNotFoundException extends NoteException{
  NoteNotFoundException(String message) : super(message);

}

