// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../Modals/VerseModal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerseModalAdapter extends TypeAdapter<VerseModal> {
  @override
  final int typeId = 2;

  @override
  VerseModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerseModal(
      id: fields[0] as String,
      content: fields[1] as String,
      translationEng: fields[2] as String,
      audioData: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VerseModal obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.translationEng)
      ..writeByte(3)
      ..write(obj.audioData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
