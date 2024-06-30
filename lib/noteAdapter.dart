import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/note.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      title: reader.readString(),
      content: reader.readString(),
      createdAt: reader.readString(),
      updatedAt: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    print("Writing Note");
    writer.writeString(obj.title);
    writer.writeString(obj.content);
    writer.writeString(obj.createdAt);
    writer.writeString(obj.updatedAt);
  }
}