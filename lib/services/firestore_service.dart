import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // Collection: users -> {uid} -> timetables -> {timetableId}
  DocumentReference? _timetableRef(String timetableId) {
    final uid = _uid;
    if (uid == null) return null;
    return _db
        .collection('users')
        .doc(uid)
        .collection('timetables')
        .doc(timetableId);
  }

  Future<void> saveStartDate(String timetableId, DateTime startDate) async {
    try {
      final ref = _timetableRef(timetableId);
      if (ref == null) return;
      await ref.set({
        'startDate': startDate.toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving start date: $e');
    }
  }

  Future<void> saveDayCompletion(
    String timetableId,
    int dayNumber,
    bool isCompleted,
  ) async {
    try {
      final ref = _timetableRef(timetableId);
      if (ref == null) return;
      await ref.set({
        'days': {dayNumber.toString(): isCompleted},
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving day completion: $e');
    }
  }

  Future<Map<String, dynamic>?> getTimetableProgress(String timetableId) async {
    try {
      final ref = _timetableRef(timetableId);
      if (ref == null) return null;
      final snapshot = await ref.get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint('Error fetching progress: $e');
    }
    return null;
  }
}
