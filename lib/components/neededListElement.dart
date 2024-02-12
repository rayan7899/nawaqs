import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nawaqs/Models/consumption.dart';

class NeededListElement extends StatefulWidget {
  final Consumption item;
  final Function callback;
  const NeededListElement(this.item, this.callback, {super.key});

  @override
  State<NeededListElement> createState() => _NeededListElementState();
}

class _NeededListElementState extends State<NeededListElement> {
  _NeededListElementState();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => widget.item.delete(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10),
        child: const Icon(Icons.delete_outline_rounded),
      ),
      child: ListTile(
        title: Text('${widget.item.item?.name}'),
        subtitle: Text('الكمية: ${widget.item.quantity}'),
        enabled: widget.item.done == false,
        onTap: () {
          widget.callback.call();
          setState(() {
            if (widget.item.done == true) {
              widget.item.undone();
              widget.item.done = false;
            } else {
              widget.item.makeDone();
              widget.item.done = true;
            }
          });
        },
        trailing: IconButton(
          onPressed: () {
            widget.callback.call();
            setState(() {
              if (widget.item.done == true) {
                widget.item.undone();
                widget.item.done = false;
              } else {
                widget.item.makeDone();
                widget.item.done = true;
              }
            });
          },
          icon: Icon(
              widget.item.done ?? true ? Icons.done : Icons.circle_outlined),
        ),
      ),
    );
  }
}
