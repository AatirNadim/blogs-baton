import 'package:flutter/material.dart';

class Simpletext extends StatelessWidget {
  String text;

  Simpletext({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: Key(text),
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        backgroundColor: Colors.deepPurpleAccent,
        color: Colors.white,
      ),
    );
  }
}
