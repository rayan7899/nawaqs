import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Consumer {
  final auth = FirebaseAuth.instance;
  Consumer() {
    ///check if user signed out and make him signed in
    auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        await FirebaseAuth.instance.signInAnonymously().then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(value.user?.uid)
              .set({'level': 2});
          print('-------------- User is signed up!');
        });
      } else {
        print('-------------- User is signed in!');
      }
    });
  }
}
