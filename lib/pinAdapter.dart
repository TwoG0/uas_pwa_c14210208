import 'package:hive_flutter/hive_flutter.dart';
import 'package:uas_ambw/pin.dart';


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