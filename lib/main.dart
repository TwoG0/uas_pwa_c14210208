import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uas_ambw/Page/registerPin.dart';
import 'package:uas_ambw/note.dart';
import 'package:uas_ambw/noteAdapter.dart';
import 'package:uas_ambw/pin.dart';
import 'package:uas_ambw/pinAdapter.dart';
import 'package:uas_ambw/Page/pinPage.dart';
import 'package:uas_ambw/Theme/lightMode.dart';

late Box<bool> lightModeBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive and adapters
  final appDocumentDir = await getApplicationDocumentsDirectory();
  debugPrint("App Document Directory: ${appDocumentDir.path}");
  
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(PinAdapter());

  // Open Hive boxes
  try {
    await Hive.openBox<Note>('notes');
    await Hive.openBox<Pin>('pin');
    lightModeBox = await Hive.openBox<bool>('light_mode');

    // Initialize light mode box if empty
    if (lightModeBox.isEmpty) {
      await lightModeBox.add(true);
    }

    // Set initial light mode state
    isLightMode = lightModeBox.get(0) ?? true;
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
    // Handle initialization error, e.g., show a message or retry
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          try {
            if (box.isEmpty) {
              return RegisterPin();
            } else {
              return PinPage();
            }
          } catch (e) {
            debugPrint('Error building home: $e');
            // Handle error, e.g., return a default screen or show an error message
            return Container();
          }
        },
      ),
    );
  }
}
