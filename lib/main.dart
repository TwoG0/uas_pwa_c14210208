import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  debugPrint("App Document Directory: ${appDocumentDir.path}");
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(PinAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Pin>('pin');
  runApp(const MyApp());
}

class Note {
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    print("Reading Note");
    return Note(
      content: reader.readString(),
      createdAt: reader.read() as DateTime,
      updatedAt: reader.read() as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    print("Writing Note");
    writer.writeString(obj.content);
    writer.write(obj.createdAt);
    writer.write(obj.updatedAt);
  }
}

class Pin {
  String pin;

  Pin({required this.pin});
}

class PinAdapter extends TypeAdapter<Pin> {
  @override
  final typeId = 1;

  @override
  Pin read(BinaryReader reader) {
    print("Reading Pin");
    return Pin(pin: reader.readString());
  }

  @override
  void write(BinaryWriter writer, Pin obj) {
    print("Writing Pin");
    writer.writeString(obj.pin);
  }
}

class PinPage extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: 'PIN'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pinBox = Hive.box<Pin>('pin');
                if (pinBox.isEmpty) {
                  print("Adding new PIN");
                  pinBox.add(Pin(pin: _pinController.text));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } else {
                  print("Checking existing PIN");
                  final savedPin = pinBox.getAt(0)!.pin;
                  if (_pinController.text == savedPin) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Incorrect PIN')),
                    );
                  }
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No notes yet'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index);
              return ListTile(
                title: Text(note!.content),
                subtitle: Text(
                    'Created: ${note.createdAt}\nUpdated: ${note.updatedAt}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotePage(note: note, index: index),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    box.deleteAt(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

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

class SettingsPage extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: 'New PIN'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pinBox = Hive.box<Pin>('pin');
                pinBox.putAt(0, Pin(pin: _pinController.text));
                Navigator.pop(context);
              },
              child: Text('Change PIN'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ValueListenableBuilder(
        valueListenable: Hive.box<Pin>('pin').listenable(),
        builder: (context, Box<Pin> box, _) {
          if (box.isEmpty) {
            return PinPage();
          } else {
            return PinPage();
          }
        },
      ),
    );
  }
}
