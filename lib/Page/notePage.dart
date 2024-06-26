import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/note.dart';

class NotePage extends StatefulWidget {
  final Note? note;
  final int? index;

  NotePage({this.note, this.index});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final box = Hive.box<Note>('notes');
                if (widget.note == null) {
                  print("Adding new Note");
                  final newNote = Note(
                    content: _contentController.text,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  box.add(newNote);
                } else {
                  print("Updating Note");
                  final updatedNote = widget.note!;
                  updatedNote.content = _contentController.text;
                  updatedNote.updatedAt = DateTime.now();
                  box.putAt(widget.index!, updatedNote);
                }
                Navigator.pop(context);
              },
              child: Text(widget.note == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}