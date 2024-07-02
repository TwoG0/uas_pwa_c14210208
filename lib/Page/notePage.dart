import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/note.dart';
import 'package:uas_ambw/Theme/lightMode.dart';
import 'package:intl/intl.dart';

class NotePage extends StatefulWidget {
  final Note? note;
  final int? index;

  NotePage({this.note, this.index});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _contentController.text = widget.note!.content;
      _titleController.text = widget.note!.title;
    }
  }

  void Save() {
    final box = Hive.box<Note>('notes');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    if (widget.note != null) {
      print("Updating Note");
      final updatedNote = widget.note!;
      updatedNote.title = _titleController.text;
      updatedNote.content = _contentController.text;
      updatedNote.updatedAt = formattedDate;
      box.putAt(widget.index!, updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(),
        title: Text(
          widget.note == null ? 'Add Note' : 'Edit Note',
          style: TextStyle(color: getFontColor()),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: getFontColor(),
          ),
          onPressed: () {
            final box = Hive.box<Note>('notes');
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('yyyy-MM-dd').format(now);
            if (_titleController.text.isNotEmpty ||
                _contentController.text.isNotEmpty) {
              if (widget.note == null) {
                print("Adding new Note");
                final newNote = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: formattedDate,
                  updatedAt: formattedDate,
                );
                box.add(newNote);
              } else {
                print("Updating Note");
                final updatedNote = widget.note!;
                updatedNote.title = _titleController.text;
                updatedNote.content = _contentController.text;
                updatedNote.updatedAt = formattedDate;
                box.putAt(widget.index!, updatedNote);
              }
            }

            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Text field untuk title
              Container(
                decoration: BoxDecoration(
                  color: getCardColor(),
                  borderRadius: BorderRadius.circular(
                      12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    onChanged: (value) => Save(),
                    controller: _titleController,
                    style: TextStyle(color: getFontColor()),
                    decoration: InputDecoration(
                      hintText: 'Enter your title',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade200, fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(height: 50),
              //Text field untuk content
              Container(
                decoration: BoxDecoration(
                  color: getCardColor(),
                  borderRadius: BorderRadius.circular(
                      12.0),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      onChanged: (value) => Save(),
                      controller: _contentController,
                      style: TextStyle(color: getFontColor()),
                      decoration: InputDecoration(
                        border: InputBorder.none
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
