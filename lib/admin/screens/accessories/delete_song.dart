
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/module/Song_module.dart';

import 'package:music_app/play_now.dart';

import 'package:path/path.dart' as Path;

class Delete_Song extends StatefulWidget {
  static const routename = 'Delete_Song';
  @override
  _Delete_SongState createState() => _Delete_SongState();
}

class _Delete_SongState extends State<Delete_Song> {

int a=0;
  Future deleteData(int key_id) async {
    Box boxx=await  Hive.openBox('songs');
    await boxx.deleteAt(key_id).then((value) {
      setState(() {
    a=1;
      });

    });
  }

  List<Song_Module> folder1 = [];
  List<Song_Module> folder2 = [];
  List<Song_Module> folder3 = [];

  Future<List<Song_Module>> fetch_music() async {
    List<Song_Module> songs = [];
    folder1 = [];
    folder2 = [];
    folder3 = [];

    Box boxx = await Hive.openBox('songs');
    final songsBox = boxx;
    print("start");
    int count = 0;
    await Future.forEach(songsBox.values, (element) async {
      Song_Module instance = element as Song_Module;

      songs.add(Song_Module(
          title: instance.title,
          description: instance.description,
          foldername: instance.foldername,
          image_path: instance.image_path,
          Song_File_path: instance.Song_File_path,
          song_index: count));
      count++;
    }).then((value) {
      Hive.close();
    });
    return songs;
  }

  List<String> songs_folders = ['Folder1', 'Folder2', 'Folder3'];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFB98959),
          appBar: AppBar(
            title: Text(
              'Delete Songs ',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            elevation: 0,
            backgroundColor:Color(0xFFB98959),
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: FutureBuilder(
            future: fetch_music(),
            builder: (context, AsyncSnapshot<List<Song_Module>> snapshot) {
              return snapshot.hasData
                  ?  ListView(
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 1,
         margin: EdgeInsets.only(left: 10,right: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 1,
                      child: FutureBuilder(
                        future: fetch_music(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Song_Module>> snapshot) {
                          return snapshot.connectionState == ConnectionState.waiting
                              ? Container(
                              height: 40, width: 40, child: Text("Loading..."))
                              : snapshot.hasData
                              ? snapshot.data!.isEmpty
                              ? Center(child: Text("No Songs",style: TextStyle(color: Colors.white),))

                              :
                          ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return   Padding(
                                padding:
                                const EdgeInsets
                                    .only(
                                    left: 5.0,
                                    ),
                                child: Chip(

                                    label: ListTile(
                                    leading:
                                    CircleAvatar(
                                      backgroundImage:
                                      FileImage((File(snapshot.data![index]
                                          .image_path
                                          .toString()))),
                                    ),
                                    title: Container(
                                      height: MediaQuery.of(context).size.height*0.05,
                                      width:  MediaQuery.of(context).size.width*0.4,
                                      child: Text(snapshot.data![index]
                                          .title
                                          .toString()),
                                    ),
                                    trailing:
                                    Container(

                                     width: MediaQuery.of(context).size.width*0.3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              List<AudioTrack> new_list = [];
                                              folder1.forEach((element) {
                                                new_list.add(
                                                  // Musics(title: element.title, image: element.image_path, singer: element.description, url: element.Song_File_path)
                                                    AudioTrack(title:element.title ,assetUrl: element.Song_File_path,album: element.description,artist: element.description)
                                                );

                                              });


                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>
                                                    Play_Now_Screen(songs_list: new_list,)
                                                  // NowPlaying(mMusic: new_list,currentIndex: index,)
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20)
                                                 , color: Color(0xFFB98959),
                                              ),

                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Text("Play",style: TextStyle(color: Colors.white),),
                                                )),
                                          ),
                                          IconButton(onPressed: (){
                                    deleteData(snapshot.data![index].song_index).then((value) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully"),backgroundColor: Colors.green,));

                                    });



                                          }, icon: Icon(Icons.delete,color: Colors.red,)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )

                              : Center(child: Text("No Songs"));
                        },
                        // .map(
                        //     (e) =>
                        //     Padding(
                        //       padding: const EdgeInsets.only(
                        //           left:
                        //           8.0,
                        //           right:
                        //           10),
                        //       child:
                        //       ListTile(
                        //         onTap: (){
                        //
                        //         },
                        //         leading:
                        //         CircleAvatar(
                        //           backgroundImage:
                        //           FileImage((File(e.image_path.toString()))),
                        //         ),
                        //         title: Text(e
                        //             .title
                        //             .toString()),
                        //         trailing: RaisedButton(
                        //             onPressed: () {
                        //
                        //               List<Musics> new_list = [];
                        //               folder3.forEach((element) {
                        //                 new_list.add(
                        //                     Musics(title: element.title, image: element.image_path, singer: element.description, url: element.Song_File_path)
                        //
                        //                 );
                        //
                        //               });
                        //
                        //
                        //               Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(builder: (context) => NowPlaying(mMusic: new_list)),
                        //               );
                        //             },
                        //             child: Text("Play")),
                        //       ),
                        //     ))
                        // .toList()
                      ),
                    ),
                  ),
                ],
              )
                  : SpinKitCircle(
                color: Colors.black,
              );
            },
          )),
    );
  }
}
