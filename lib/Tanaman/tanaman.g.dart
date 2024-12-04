// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tanaman.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TanamanAdapter extends TypeAdapter<Tanaman> {
  @override
  final int typeId = 0;

  @override
  Tanaman read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tanaman(
      namaTanaman: fields[0] as String,
      namaLatin: fields[1] as String,
      deskripsi: fields[2] as String,
      img: fields[3] as String,
      kategori: (fields[4] as List).cast<String>(),
      jenisTanaman: (fields[5] as List).cast<int>(),
      musim: (fields[6] as List).cast<String>(),
      lamaMasaTanam: (fields[7] as List).cast<int>(),
      pupuk: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Tanaman obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.namaTanaman)
      ..writeByte(1)
      ..write(obj.namaLatin)
      ..writeByte(2)
      ..write(obj.deskripsi)
      ..writeByte(3)
      ..write(obj.img)
      ..writeByte(4)
      ..write(obj.kategori)
      ..writeByte(5)
      ..write(obj.jenisTanaman)
      ..writeByte(6)
      ..write(obj.musim)
      ..writeByte(7)
      ..write(obj.lamaMasaTanam)
      ..writeByte(8)
      ..write(obj.pupuk);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TanamanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
