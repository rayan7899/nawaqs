import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nawaqs/Models/classification.dart';
import 'package:nawaqs/Models/consumer.dart';
import 'package:nawaqs/Models/item.dart';
import 'package:nawaqs/components/createItemSheet.dart';
import 'package:nawaqs/components/itemsListElement.dart';

class AllItems extends StatefulWidget {
  const AllItems({super.key});

  @override
  State<AllItems> createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  Classification? _selectedClassification;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اضافة منتج للنواقص'),
      ),
      body: Column(children: [
        _allClassifications(),
        _allItems(),
      ]),
      floatingActionButton: const CreateItemSheet(),
    );
  }

  _allClassifications() {
    return SizedBox(
      height: 50,
      child: FutureBuilder(
        future: Classification().getClassifications(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: _selectedClassification?.name ==
                                snapshot.data?.elementAt(index).name
                            ? const MaterialStatePropertyAll(Colors.blueGrey)
                            : null,
                        foregroundColor: _selectedClassification?.name ==
                                snapshot.data?.elementAt(index).name
                            ? const MaterialStatePropertyAll(Colors.white)
                            : null,
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.zero),
                        alignment: AlignmentDirectional.bottomCenter),
                    onPressed: () {
                      setState(() {
                        _selectedClassification =
                            snapshot.data?.elementAt(index);
                      });
                    },
                    child: Text('${snapshot.data?.elementAt(index).name}'),
                  ),
                );
              });
        },
      ),
    );
  }

  _allItems() {
    return Expanded(
      child: FutureBuilder(
        key: UniqueKey(),
        future: _selectedClassification == null
            ? Item().getItems()
            : _selectedClassification!.items(),
        builder: (context, itemsSnapshot) {
          if (itemsSnapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder(
            future: Consumer().level(),
            builder: (context, lvlSnapshot) {
              if (lvlSnapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  key: UniqueKey(),
                  itemCount: itemsSnapshot.data?.length,
                  itemBuilder: (context, index) {
                    if (itemsSnapshot.data != null) {
                      return ItemsListElement(
                        item: itemsSnapshot.data!.elementAt(index),
                        userLevel: lvlSnapshot.data!,
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
