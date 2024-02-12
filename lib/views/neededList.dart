import 'package:flutter/material.dart';
import 'package:nawaqs/Models/consumption.dart';
import 'package:nawaqs/components/neededListElement.dart';
import 'package:nawaqs/views/allItems.dart';
import 'package:nawaqs/views/history.dart';

class NeededList extends StatefulWidget {
  const NeededList({super.key});

  @override
  State<NeededList> createState() => _NeededListState();
}

class _NeededListState extends State<NeededList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نواقص')),
      body: _itemsList(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: FloatingActionButton(
              heroTag: 1,
              child: const Icon(Icons.history_rounded),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const History(),
                ));
              },
            ),
          ),
          FloatingActionButton(
            heroTag: 0,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => const AllItems(),
              ))
                  .then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }

  _itemsList() {
    return FutureBuilder(
      future: Consumption().neededItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('لا يوجد نواقص'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
                key: UniqueKey(),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Consumption? item = snapshot.data?[index];
                  return NeededListElement(
                    item!,
                    () => setState(() {}),
                    key: ValueKey(item),
                  );
                }),
          );
        } else {
          return const Text('error');
        }
      },
    );
  }
}
