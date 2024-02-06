import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nawaqs/Models/classification.dart';

class Item {
  final DocumentReference? itemRef;
  String? name;
  DocumentReference? classificationDoc;

  Item({this.name, this.classificationDoc, this.itemRef});

  CollectionReference ref = FirebaseFirestore.instance.collection('items');

  Future<List<Item>> getItems({DocumentReference? classificationRef}) async {
    late QuerySnapshot itemsSnap;
    if (classificationRef == null) {
      itemsSnap = await ref
          .where('deleted', isEqualTo: false)
          .orderBy('classification')
          .get();
    } else {
      itemsSnap = await ref
          .where('classification', isEqualTo: classificationRef)
          .where('deleted', isEqualTo: false)
          .orderBy('classification')
          .get();
    }

    List<QueryDocumentSnapshot> itemsDocs = itemsSnap.docs;

    List<Item> items = List<Item>.empty(growable: true);

    for (QueryDocumentSnapshot item in itemsDocs) {
      items.add(Item(
          itemRef: item.reference,
          name: item.get('name'),
          classificationDoc: item.get('classification')));
    }
    return items;
  }

  Future<Classification> classification() async {
    DocumentSnapshot _classDoc = await classificationDoc!.get();
    return Classification(
        name: _classDoc.get('name'), classificationRef: _classDoc.reference);
  }

  Future<DocumentReference> makeConsumption() async {
    final DocumentReference userDocumentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid.toString());
    QuerySnapshot oldConsumption = await userDocumentReference
        .collection('neededItems')
        .where('item', isEqualTo: itemRef)
        .where('done', isEqualTo: false)
        .get();
    if (oldConsumption.docs.isNotEmpty) {
      oldConsumption.docs.first.reference.set(
          {'quantity': oldConsumption.docs.first.get('quantity') + 1},
          SetOptions(merge: true));
      return oldConsumption.docs.first.reference;
    } else {
      final consumptionRef =
          await userDocumentReference.collection('neededItems').add({
        'item': itemRef,
        'quantity': 1,
        'addedAt': DateTime.now(),
        'done': false,
        'doneAt': null,
      });
      return consumptionRef;
    }
  }

  Future<bool> delete() async {
    try {
      // QuerySnapshot consumptionsQuery = await FirebaseFirestore.instance
      //     .collectionGroup('neededItems')
      //     .where('item', isEqualTo: itemRef)
      //     .get();
      // consumptionsQuery.docs.map((e) => e.reference.delete());
      // await itemRef?.delete();
      itemRef!.set({
        'deleted': true,
        'deleted_at': DateTime.now(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
