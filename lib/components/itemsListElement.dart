import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nawaqs/Models/item.dart';

class ItemsListElement extends StatefulWidget {
  final Item item;
  final int userLevel;
  const ItemsListElement(
      {required this.item, required this.userLevel, super.key});

  @override
  State<ItemsListElement> createState() =>
      _ItemsListElement(item: item, userLevel: userLevel);
}

class _ItemsListElement extends State<ItemsListElement> {
  final Item? item;
  final int userLevel;
  _ItemsListElement({this.item, required this.userLevel});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: item?.classification(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              ListTile(
                title: Text('${item?.name}'),
                subtitle: Text('${snapshot.data!.name}'),
                trailing: _actionButtons(),
              ),
              const Divider()
            ],
          );
        }
      },
    );
  }

  Widget _actionButtons() {
    bool isAdd = false;
    return Container(
      alignment: Alignment.centerLeft,
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              return IconButton(
                onPressed: () {
                  item?.makeConsumption().then((value) {
                    setState(() {
                      isAdd = true;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('تم اضافة ${item?.name} الى النواقص'),
                      ));
                    });
                  });
                },
                icon: isAdd
                    ? const Icon(Icons.done)
                    : const Icon(Icons.add_shopping_cart_rounded),
                padding: const EdgeInsets.all(0),
              );
            },
          ),
          // if (userLevel == 1)
          //   IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.edit_outlined),
          //     color: const Color.fromARGB(255, 0, 98, 255),
          //     padding: const EdgeInsets.all(0),
          //   ),
          if (userLevel == 1)
            IconButton(
              onPressed: () {
                item!.delete().then((value) {
                  setState(() {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('تم حذف ${item?.name} بنجاح'),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('تعذر حذف ${item?.name}'),
                      ));
                    }
                  });
                });
              },
              icon: const Icon(Icons.delete_outline_rounded),
              color: const Color.fromARGB(255, 175, 0, 0),
              padding: const EdgeInsets.all(0),
            ),
        ],
      ),
    );
  }
}
