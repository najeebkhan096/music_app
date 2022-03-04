import 'dart:io';

import 'package:music_app/module/Song_module.dart';

class Local_Songs{

  String ? foldername;
  List<Song_Module> ? songs;
  String ? album_image;
  bool ? status;

  Local_Songs({this.foldername,this.songs,this.album_image,this.status});

}