import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nawaqs/Models/item.dart';

class Classification {
  DocumentReference? classificationRef;
  String? name;

  Classification({this.name, this.classificationRef});

  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('classifications');

  Future<List<Classification>> getClassifications() async {
    QuerySnapshot classificationsSnap = await _ref.get();

    List<QueryDocumentSnapshot> classificationsDocs = classificationsSnap.docs;

    List<Classification> classifications =
        List<Classification>.empty(growable: true);

    for (QueryDocumentSnapshot classification in classificationsDocs) {
      classifications.add(Classification(
          name: classification.get('name'),
          classificationRef: classification.reference));
    }
    return classifications;
  }

  Future<Classification> find(DocumentReference classificationId) async {
    DocumentSnapshot classDoc = await classificationId.get();
    return Classification(
      name: classDoc.get('name'),
      classificationRef: classificationId,
    );
  }

  Future<List<Item>> items() async {
    CollectionReference itemsRef =
        FirebaseFirestore.instance.collection('items');

    QuerySnapshot itemsSnap = await itemsRef
        .where('classification', isEqualTo: classificationRef)
        .where('deleted', isEqualTo: false)
        .get();

    List<Item> items = List<Item>.empty(growable: true);

    for (QueryDocumentSnapshot item in itemsSnap.docs) {
      items.add(
        Item(
          itemRef: item.reference,
          name: item.get('name'),
          classificationDoc: item.get('classification'),
        ),
      );
    }
    return items;
  }

  Future<bool> createItem({required String name}) async {
    try {
      await FirebaseFirestore.instance.collection('items').add({
        'classification': classificationRef,
        'name': name,
        'create_date': DateTime.now(),
        'deleted': false,
      });

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> newClassification({required String name}) async {
    try {
      await FirebaseFirestore.instance.collection('classifications').add({
        'name': name,
        'create_date': DateTime.now(),
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      List<Item> items = await this.items();
      items.map((e) async => await e.delete());

      await classificationRef?.delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
