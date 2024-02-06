import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nawaqs/Models/item.dart';

// this model show item usage
class Consumption {
  final DocumentReference? consumptionRef;
  Item? item;
  int? quantity;
  bool? done;
  DateTime? doneAt;
  DateTime? addedAt;

  final DocumentReference _userDocumentReference = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid.toString());

  Consumption({
    this.item,
    this.quantity,
    this.done,
    this.doneAt,
    this.consumptionRef,
  });

  Future<List<Consumption>> neededItems() async {
    QuerySnapshot querySnapshot = await _userDocumentReference
        .collection('neededItems')
        .orderBy('doneAt')
        .orderBy('addedAt', descending: true)
        .get();
    List<Consumption> consumptions = List<Consumption>.empty(growable: true);

    for (QueryDocumentSnapshot consumption in querySnapshot.docs) {
      DocumentReference itemRef = consumption.get('item');
      DocumentSnapshot item = await itemRef.get();

      consumptions.add(Consumption(
        consumptionRef: consumption.reference,
        item: Item(name: item.get('name')),
        done: consumption.get('done'),
        quantity: consumption.get('quantity'),
        doneAt: consumption.get('doneAt')?.toDate(),
      ));
    }
    return consumptions;
  }

  Future<bool> makeDone() async {
    return consumptionRef!
        .set({'done': true, 'doneAt': Timestamp.now()}, SetOptions(merge: true))
        .then((value) => true)
        .onError((error, stackTrace) {
          log(error.toString(), stackTrace: StackTrace.current);
          return false;
        });
  }

  Future<bool> undone() async {
    return consumptionRef!
        .set({'done': false, 'doneAt': null}, SetOptions(merge: true))
        .then((value) => true)
        .onError((error, stackTrace) {
          log(error.toString(), stackTrace: stackTrace);
          return false;
        });
  }

  Future<bool> increaseQuantity() async {
    final consumption = await consumptionRef?.get();
    consumptionRef?.set({'quantity': consumption?.get('quantity') + 1},
        SetOptions(merge: true));
    return true;
  }

  Future<bool> decreaseQuantity() async {
    final consumption = await consumptionRef?.get();
    consumptionRef?.set({'quantity': consumption?.get('quantity') - 1},
        SetOptions(merge: true));
    return true;
  }

  Future<bool> delete() async {
    try {
      await consumptionRef?.delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'quantity': quantity,
      'done': done,
      'doneAt': doneAt,
      'addedAt': addedAt,
    };
  }
}
