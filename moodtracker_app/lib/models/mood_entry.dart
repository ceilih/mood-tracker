//model for each days entry
//includes

//date - required
//mood - required
//notes - optional

import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';


class MoodEntry {
  late String _mood;
  late DateTime _date;
  late String? _notes;
  late String? _id;

  MoodEntry({
    required String mood,
    required DateTime date,
    String? notes,
    String? id,
  }) {
    _mood = mood;
    _date = date;
    _notes = notes;
    _id = id;
  }

  // getter and setters for fields
  String get mood {
    return _mood;
  }

  set mood(String value) {
    if (value.isEmpty) {
      throw Exception('Must select mood input');
    }
    _mood = value;
  }

  DateTime get date {
    return _date;
  }

  set date(DateTime? value) {
    //if no date is passed in, will default to now
    value ??= DateTime.now();
    _date = value;
  }

  String? get notes {
    return _notes;
  }

  set notes(String? value) {
    _notes = value;
  }

  String? get id {
    return _id;
  }

  set id(String? value) {
    _id = value;
  }

  factory MoodEntry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;

    //convert firebase Timestamp to DateTime
    DateTime? dateTime = (data['date'] as Timestamp?)?.toDate();

    return MoodEntry(
      mood: data['mood'],
      date: dateTime!,
      notes: data['notes'],
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {'mood': mood, 'date': date, 'notes': notes};
  }
}
