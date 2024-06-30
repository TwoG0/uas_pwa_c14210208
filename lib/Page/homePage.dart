import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/Theme/lightMode.dart';
import 'package:uas_ambw/note.dart';
import 'package:uas_ambw/Page/notePage.dart';
import 'package:uas_ambw/Page/settingsPage.dart';
import 'package:uas_ambw/Card/homePageCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _dataChanged =
      false; // Untuk memberitahu homePage jika ada perubahaan ketika back dari halaman lain

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(),
        title: Text(
          'Notes',
          style: TextStyle(color: getFontColor()),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: getFontColor()),
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );

              if (result != null && result) {
                setState(() {
                  _dataChanged = true;
                });
              }
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No notes yet'));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  childAspectRatio: 0.46,
                ),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final note = box.getAt(index);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotePage(note: note, index: index),
                        ),
                      );
                    },
                    child: GridTile(
                      child: Column(
                        children: [
                          Card.filled(
                            color: getCardColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  13.0), // Set the desired border radius here
                            ),
                            child: SampleCard(
                              note: note!,
                            ),
                          ),
                          Center(
                              child: Text(
                            '${note.title}',
                            style: TextStyle(color: getFontColor()),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          Center(
                              child: Text(
                            '${note.createdAt}',
                            style: TextStyle(color: getFontColor()),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),
                  );
                }),
          );
          // return ListView.builder(
          //   itemCount: box.length,
          //   itemBuilder: (context, index) {
          //     final note = box.getAt(index);
          //     return ListTile(
          //       title: Text(note!.content),
          //       subtitle: Text(
          //         'Created: ${note.createdAt}\nUpdated: ${note.updatedAt}',
          //       ),
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 NotePage(note: note, index: index),
          //           ),
          //         );
          //       },
          //       trailing: IconButton(
          //         icon: Icon(Icons.delete),
          //         onPressed: () {
          //           box.deleteAt(index);
          //         },
          //       ),
          //     );
          //   },
          // );
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
