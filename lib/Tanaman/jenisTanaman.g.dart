// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jenisTanaman.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JenisTanamanAdapter extends TypeAdapter<JenisTanaman> {
  @override
  final int typeId = 1;

  @override
  JenisTanaman read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JenisTanaman(
      widget: fields[3] as Widget?,
      nama: fields[0] as String,
      deskripsi: fields[1] as String,
      id: fields[5] as int,
      img: fields[2] as String,
      kategori: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, JenisTanaman obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.deskripsi)
      ..writeByte(2)
      ..write(obj.img)
      ..writeByte(3)
      ..write(obj.widget)
      ..writeByte(4)
      ..write(obj.kategori)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JenisTanamanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
