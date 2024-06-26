import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/note.dart';

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