// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Song_module.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongModuleAdapter extends TypeAdapter<Song_Module> {
  @override
  final int typeId = 1;

  @override
  Song_Module read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song_Module(
      description: fields[1] as String?,
      title: fields[0] as String?,
      image_path: fields[2] as String?,
      foldername: fields[3] as String?,
      Song_File_path: fields[4] as String?,
      song_index: fields[5] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Song_Module obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.image_path)
      ..writeByte(3)
      ..write(obj.foldername)
      ..writeByte(4)
      ..write(obj.Song_File_path)
      ..writeByte(5)
      ..write(obj.song_index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
