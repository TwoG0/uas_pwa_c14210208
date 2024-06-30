import 'package:flutter/material.dart';
import 'package:uas_ambw/Theme/lightMode.dart';
import 'package:uas_ambw/note.dart';

class SampleCard extends StatelessWidget {
  const SampleCard({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: getBackgroundColor(),
            title: Center(
                child: Text(
              '${note.title}',
              style: TextStyle(color: getFontColor()),
            )),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Created: ${note.createdAt}',
                    style: TextStyle(color: getFontColor())),
                Text('Created: ${note.updatedAt}',
                    style: TextStyle(color: getFontColor())),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: getFontColor())),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete', style: TextStyle(color: getFontColor())),
                onPressed: () {
                  // Perform delete operation here
                  // Example: Hive.box<Note>('notes').delete(note.key);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
