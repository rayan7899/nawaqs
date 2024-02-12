import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nawaqs/Models/consumption.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تاريخ النواقص')),
      body: FutureBuilder(
        future: Consumption().itemsGroupByDay(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(child: Text('لا يوجد'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 150,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${snapshot.data!.keys.elementAt(index)}'),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  snapshot.data!.values.elementAt(index).length,
                              itemBuilder: (context, _index) {
                                return FutureBuilder<Consumption>(
                                  future: snapshot.data!.values
                                      .elementAt(index)
                                      .elementAt(_index),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.data == null) {
                                        return const Center(
                                            child: Text('لا يوجد'));
                                      }
                    
                                      return SizedBox.square(
                                        dimension: 95,
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${snapshot.data!.item!.name}'),
                                              Text('الكمية ${snapshot.data!.quantity}'),
                                            ],
                                          ),
                                        ),
                                      );
                    
                    
                                    } else {
                                      return const Text('error');
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('error');
          }
        },
      ),
    );
  }
}
