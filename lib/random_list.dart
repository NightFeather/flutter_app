import 'package:flutter/material.dart';

class RandomList extends StatefulWidget {
  @override
  _RandomListState createState() => _RandomListState();
}

class _RandomListState extends State<RandomList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        int idx = i ~/ 2;
        if (i % 2 == 1) {
          return Divider();
        }

        return ListTile(
          title: Text("$idx Meow"),
        );
      },
    );
  }
}