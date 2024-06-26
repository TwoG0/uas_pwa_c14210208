import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uas_ambw/Page/registerPin.dart';
import 'package:uas_ambw/note.dart';
import 'package:uas_ambw/noteAdapter.dart';
import 'package:uas_ambw/pin.dart';
import 'package:uas_ambw/pinAdapter.dart';
import 'package:uas_ambw/Page/pinPage.dart';


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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ValueListenableBuilder(
        valueListenable: Hive.box<Pin>('pin').listenable(),
        builder: (context, Box<Pin> box, _) {
          if (box.isEmpty) {
            return RegisterPin();
          } else {
            return PinPage();
          }
        },
      ),
    );
  }
}




