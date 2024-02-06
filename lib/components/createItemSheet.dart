import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nawaqs/Models/classification.dart';
import 'package:nawaqs/Models/consumer.dart';

class CreateItemSheet extends StatefulWidget {
  const CreateItemSheet({super.key});

  @override
  State<CreateItemSheet> createState() => _CreateItemSheetState();
}

class _CreateItemSheetState extends State<CreateItemSheet> {
  DocumentReference? _selectedClassificationRef;
  Classification? _selectedClassification;
  String _newItemName = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Consumer().level(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Text('');
        } else {
          if (snapshot.data == 1) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              _classificationSelector(setState),
                              FormField(
                                builder: (field) {
                                  return TextField(
                                    enabled: _selectedClassification == null
                                        ? false
                                        : true,
                                    onChanged: (value) => _newItemName = value,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('اسم المنتج')),
                                  );
                                },
                              ),
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)
                                ),
                                onPressed: () {
                                  _selectedClassification!
                                      .createItem(name: _newItemName)
                                      .then((value) => Navigator.pop(context));
                                },
                                child: const Text('إضافة'),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ).whenComplete(() {
                  _selectedClassification = null;
                  _selectedClassificationRef = null;
                  _newItemName = '';
                });
                setState(() {});
              },
            );
          } else {
            return const Text('');
          }
        }
      },
    );
  }

  Widget _classificationSelector(setState) {
    return FutureBuilder(
      future: Classification().getClassifications(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return DropdownButton(
            isExpanded: true,
            borderRadius: BorderRadius.circular(8),
            hint: const Text('اختر الفئة'),
            value: _selectedClassificationRef,
            items: snapshot.data
                ?.map((e) => DropdownMenuItem(
                      value: e.classificationRef,
                      child: Text(e.name.toString()),
                    ))
                .toList(),
            onChanged: (value) async {
              _selectedClassification = await Classification().find(value!);
              setState(() {
                _selectedClassificationRef = value;
              });
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _itemsSelector(Classification selectedClassification) {
    return FutureBuilder(
      future: selectedClassification.items(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return DropdownButton(
            items: snapshot.data!
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text('${e.name}'),
                    ))
                .toList(),
            onChanged: (value) {},
          );
        } else {
          return DropdownButton(
            items: [],
            onChanged: (value) {},
          );
        }
      },
    );
  }
}
