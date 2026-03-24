import 'package:flutter/material.dart';

import 'package:moodtracker_app/models/mood_entry.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//this says import everything but emailauthprovider so that it does not conflict
//with firebase ui auth
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  //USER/LOGIN INFO
  bool _loggedIn = false;
  //This is in notes: isloggedin does not appear or is referenced otherwise - what does it do?
  //should just be setting loggedin value based on init (?)
  bool get isLoggedIn => _loggedIn;

  User? _currentUser;
  User? get user => _currentUser;

  set user(User? user) {
    if (user == null) {
      //consider making this error message more user friendly?
      throw ArgumentError('Cannot set user to null');
    }
    _currentUser = user;
  }

  //MOOD MANAGEMENT

  List<MoodEntry>? _moodList;

  List<MoodEntry>? get moodList {
    if (user == null) {
      throw ArgumentError('Must be logged in');
    }
    return _moodList;
  }

  set moodList(List<MoodEntry> moodList) {
    if (user == null) {
      throw ArgumentError('Must be logged in');
    }
    _moodList = moodList;
  }

  void _fetchMoodEntries() {
    if (user == null) {
      throw ArgumentError('Must be logged in');
    }
    FirebaseFirestore.instance
        .collection('/moodentries/${user!.uid}/moodentries')
        .get()
        .then((collectionSnapshot) {
          moodList = collectionSnapshot.docs
              .map((doc) => MoodEntry.fromFirestore(doc))
              .toList();
        });
  }

  void createMoodEntry(MoodEntry moodEntry) {
    if (user == null) {
      throw ArgumentError('Must be logged in');
    }

    //check if entry exists, update instead of creating new
    if (moodList != null) {
      for (var entry in moodList!) {
        if (entry.date == moodEntry.date) {
          moodEntry.id = entry.id;
          updateMoodEntry(moodEntry);
          return;
        }
      }
    }

    FirebaseFirestore.instance
        .collection('/moodentries/${user!.uid}/moodentries')
        .doc()
        .set(moodEntry.toMap());

    _fetchMoodEntries();
  }

  void updateMoodEntry(MoodEntry moodEntry) {

    FirebaseFirestore.instance
        .collection('/moodentries/${user!.uid}/moodentries')
        .doc(moodEntry.id)
        .update(moodEntry.toMap());
        
    _fetchMoodEntries();
  }

  void deleteMoodEntry(MoodEntry moodEntry) {
    if (user == null) {
      throw ArgumentError('Must be logged in');
    }

    moodList!.remove(moodEntry);

    FirebaseFirestore.instance
        .collection('/moodentries/${user!.uid}/moodentries')
        .doc(moodEntry.id)
        .delete()
        .then((_) {
          moodList!.remove(moodEntry);
        });
  }

  void init() async {
    //connecting to firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //set up auth providers
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    //bind a listener
    FirebaseAuth.instance.userChanges().listen((user) {
      //when the user changes, check if null and update "loggedin"
      if (user != null) {
        _loggedIn = true;
        //store loggedin user in state
        this.user = user;
        //everytime user changes (most important on login)
        _fetchMoodEntries();
      } else {
        _loggedIn = false;
      }
      //need this to pass on that the change has happened
      notifyListeners();
    });
  }
}
