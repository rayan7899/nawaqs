import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Consumer {
  final auth = FirebaseAuth.instance;
  late DocumentReference<Map<String, dynamic>> _userDocumentRef;
  Consumer() {
    ///check if user signed out and make him signed in
    if (auth.currentUser == null) {
      FirebaseAuth.instance.signInAnonymously().then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(value.user?.uid)
            .set({'level': 2});
        _userDocumentRef =
            FirebaseFirestore.instance.collection('users').doc(value.user?.uid);
        log('User is signed up!');
      });
    } else {
      log('User is signed in!');
      _userDocumentRef = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid);
    }
    log(auth.currentUser!.uid);
  }

  Future<int> level() async {
    DocumentSnapshot userSnap = await _userDocumentRef.get();
    return userSnap.get('level');
  }
}
