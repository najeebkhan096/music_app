import 'dart:io';
import 'package:hive/hive.dart';
part  'Song_module.g.dart';

@HiveType(typeId: 1)
class Song_Module{
  @HiveField(0)
  final String ? title;
  @HiveField(1)
  final String ? description;
  @HiveField(2)
  final String ? image_path;
  @HiveField(3)
  final String ?foldername;
  @HiveField(4)
  final String ? Song_File_path;
  @HiveField(5)

  final song_index;


  Song_Module({
    this.description,
   this.title,
 this.image_path,
   this.foldername,
    this.Song_File_path,
    this.song_index
  });
}
