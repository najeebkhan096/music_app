
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:music_app/module/Song_module.dart';

import 'package:music_app/play_now.dart';

import 'package:path/path.dart' as Path;

class Song_Home_Screen extends StatefulWidget {
  static const routename = 'Song_Home_Screen';
  @override
  _Song_Home_ScreenState createState() => _Song_Home_ScreenState();
}

class _Song_Home_ScreenState extends State<Song_Home_Screen> {
  List<Song_Module> folder1 = [];
  List<Song_Module> folder2 = [];
  List<Song_Module> folder3 = [];

  Future<List<Song_Module>> fetch_music() async {
    List<Song_Module> songs = [];
    folder1 = [];
    folder2 = [];
    folder3 = [];
    Box boxx=await  Hive.openBox('songs');
    final songsBox = boxx;
    await Future.forEach(songsBox.values, (element) async {
      Song_Module instance = element as Song_Module;
      if (instance.foldername == 'Folder1') {
        folder1.add(instance);
      } else if (instance.foldername == 'Folder2') {
        folder2.add(instance);
      } else if (instance.foldername == 'Folder3') {
        folder3.add(instance);
      }
      songs.add(instance);
    }).then((value) {
      Hive.close();
    });


    print(songs);
    return songs;
  }

  List<String> songs_folders = ['Folder1', 'Folder2', 'Folder3'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar:AppBar(
            title: Text("Album",style: TextStyle(color: Colors.black,fontSize: 15),),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: ListView(
            children: [
              Stack(

                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),

                  ),

                  Container(
                    height: MediaQuery.of(context).size.height*1,
                    child: FutureBuilder(
                      future: fetch_music(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Song_Module>> snapshot) {
                        return snapshot.connectionState == ConnectionState.waiting
                            ? SpinKitCircle(color: Colors.black,)
                            : snapshot.hasData
                            ? snapshot.data!.isEmpty
                            ? Center(child: Text("No Songs"))
                            : Container(
                          margin: EdgeInsets.only(top: 100,left: 10,right: 10),
                          child: ListView.builder(
                            itemCount: songs_folders.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    child: ExpansionTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/images/AlbumArt.jpg'),
                                        ),
                                        title: Text(
                                          songs_folders[index],
                                        ),
                                        children: index == 0
                                            ? [
                                          folder1.length>0?
                                          Container(
                                            height: MediaQuery.of(context).size.height*(0.17*snapshot.data!.length),
                                            child: ListView.builder(itemBuilder: (context,index){
                                              return Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 10),
                                                child:
                                                ListTile(
                                                  leading:
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    FileImage((File(folder1[index]
                                                        .image_path
                                                        .toString()))),
                                                  ),
                                                  title: Text(folder1[index]
                                                      .title
                                                      .toString()),
                                                  trailing:
                                                  RaisedButton(
                                                      onPressed:
                                                          () {
                                                        int _song_index=0;
                                                        print("akbar");
                                                        List<AudioTrack> new_list = [];
                                                        folder1.forEach((element) {
                                                          new_list.add(
                                                            // Musics(title: element.title, image: element.image_path, singer: element.description, url: element.Song_File_path)
                                                              AudioTrack(title:element.title ,assetUrl: element.Song_File_path,album: element.foldername,artist: element.description,trackId: _song_index.toString(),albumArt: element.image_path)
                                                          );
                                                          _song_index++;
                                                        }
                                                        );

//
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) =>
                                                              Play_Now_Screen(songs_list: new_list,current_index: index,)
                                                            // NowPlaying(mMusic: new_list,currentIndex: index,)
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          "Play")),
                                                ),
                                              );
                                            },
                                              itemCount: folder1.length,
                                            ),
                                          ):
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text("No Songs"),
                                          )
                                        ]
                                            : index == 1
                                            ? [

                                          folder2.length>0?
                                          Container(
                                            height: MediaQuery.of(context).size.height,
                                            child: ListView.builder(itemBuilder: (context,index){
                                              return Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 10),
                                                child:

                                                ListTile(
                                                  leading:
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    FileImage((File(folder2[index]
                                                        .image_path
                                                        .toString()))),
                                                  ),
                                                  title: Text(folder2[index]
                                                      .title
                                                      .toString()),
                                                  trailing:
                                                  RaisedButton(
                                                      onPressed:
                                                          () {
                                                        int _song_index=0;
                                                        print("akbar");
                                                        List<AudioTrack> new_list = [];
                                                        folder2.forEach((element) {
                                                          new_list.add(
                                                            // Musics(title: element.title, image: element.image_path, singer: element.description, url: element.Song_File_path)
                                                              AudioTrack(title:element.title ,assetUrl: element.Song_File_path,album: element.foldername,artist: element.description,trackId: _song_index.toString(),albumArt: element.image_path)
                                                          );
                                                          _song_index++;
                                                        }
                                                        );

//
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) =>
                                                              Play_Now_Screen(songs_list: new_list,current_index: index,)
                                                            // NowPlaying(mMusic: new_list,currentIndex: index,)
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          "Play")),
                                                ),
                                              );
                                            },
                                              itemCount: folder2.length,
                                            ),
                                          ):
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text("No Songs"),
                                          )
                                        ]
                                            : index == 2
                                            ?
                                        [
                                          folder3.length>0?
                                          Container(
                                            height: MediaQuery.of(context).size.height,
                                            child: ListView.builder(itemBuilder: (context,index){
                                              return Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 8.0,
                                                    right: 10),
                                                child:      ListTile(
                                                  leading:
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    FileImage((File(folder3[index]
                                                        .image_path
                                                        .toString()))),
                                                  ),
                                                  title: Text(folder3[index]
                                                      .title
                                                      .toString()),
                                                  trailing:
                                                  RaisedButton(
                                                      onPressed:
                                                          () {
                                                        int _song_index=0;
                                                        print("akbar");
                                                        List<AudioTrack> new_list = [];
                                                        folder3.forEach((element) {
                                                          new_list.add(
                                                            // Musics(title: element.title, image: element.image_path, singer: element.description, url: element.Song_File_path)
                                                              AudioTrack(title:element.title ,assetUrl: element.Song_File_path,album: element.foldername,artist: element.description,trackId: _song_index.toString(),albumArt: element.image_path)
                                                          );
                                                          _song_index++;
                                                        }
                                                        );

//
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) =>
                                                              Play_Now_Screen(songs_list: new_list,current_index: index,)
                                                            // NowPlaying(mMusic: new_list,currentIndex: index,)
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          "Play")),
                                                ),
                                              );
                                            },
                                              itemCount: folder3.length,
                                            ),
                                          ):
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text("No Songs"),
                                          )
                                        ]

                                            : []),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height*0.032,
                                  ),
                                ],
                              );
                            },
                          ),
                        )

                            : Center(child: Text("No Songs"));
                      },

                    ),
                  ),
                ],
              ),
            ],
          )


      ),
    );
  }
}
