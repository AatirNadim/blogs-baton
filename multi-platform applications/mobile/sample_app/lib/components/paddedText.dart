import 'package:flutter/material.dart';
import './simpleText.dart';

class PaddedText extends StatelessWidget {
  final String text;

  PaddedText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Simpletext(text: text),
    );
  }
}