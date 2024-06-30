import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uas_ambw/Theme/lightMode.dart';
import 'package:uas_ambw/note.dart';

class SampleCard extends StatelessWidget {
  const SampleCard({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: getCardColor(), // Custom function from lightMode.dart
        borderRadius: BorderRadius.circular(16.0), // Example border radius
      ),
      width: 300,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          note.content,
          style: TextStyle(
            fontSize: 12,
            color: getFontColor(), // Custom function from lightMode.dart
          ),
        ),
      ),
    );
  }
}
