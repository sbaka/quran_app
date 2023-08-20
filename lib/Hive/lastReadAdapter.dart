import 'package:hive/hive.dart';

class LastReadAdapter extends TypeAdapter<String> {
  @override
  final typeId = 1; // You can choose any unique number for typeId

  @override
  String read(BinaryReader reader) {
    return reader.readString();
  }

  @override
  void write(BinaryWriter writer, String obj) {
    writer.writeString(obj);
  }
}
