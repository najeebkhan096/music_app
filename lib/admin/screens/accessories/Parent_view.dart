import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:music_app/Sign_in_Screen.dart';
import 'package:music_app/module/Admin_drawer.dart';
import 'package:music_app/module/Local_Songs.dart';
import 'package:music_app/module/Song_module.dart';
import 'package:music_app/module/app_drawer.dart';
import 'package:music_app/module/folder.dart';
import 'package:music_app/module/myclass_clipper.dart';
import 'dart:io' as io;
import 'package:music_app/play_now.dart';
import 'package:music_app/providers/rmplayer.dart';
import 'package:music_app/screens/second_play.dart';

import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

class Parent_Screen extends StatefulWidget {
  static const routename = 'Parent_Screen';
  @override
  _Parent_ScreenState createState() => _Parent_ScreenState();
}

class _Parent_ScreenState extends State<Parent_Screen> {
  TextEditingController _foldername_controller = TextEditingController();
  void _show_EmptyList_Error(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Alert'),
              content: Text("Album is Empty"),
              actions: <Widget>[
                FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    })
              ],
            ));
  }

  Future<List<Local_Songs>> fetch() async {
    List<Local_Songs> fetched_songs = [];

    print("fetch function");
    bool choice = true;
    await Hive.openBox('songs').then((value) {
      final songsBox = Hive.box('songs');
      print("rimsha" + songsBox.toString());
      if (songsBox.isEmpty) {
        print("sania khaista ");
      } else {
        print("sania tora");
      }
      Map<dynamic, dynamic> _map = songsBox.toMap();
      _map.forEach((key, value) {
        print(key + " key heer " + value.toString());
        List<dynamic> mylist = value['songs'];
        print("multan" + value['album_pic'].toString());
        String album_pic = value['album_pic'].toString();

        List<Song_Module> def = [];
        mylist.forEach((element) {
          Song_Module abc = element as Song_Module;
          print(element);

          def.add(Song_Module(
              foldername: key,
              title: abc.title.toString(),
              image_path: abc.image_path.toString(),
              Song_File_path: abc.Song_File_path.toString(),
              song_index: abc.song_index,
              description: abc.description.toString()));
        });

        print("mehnaz" + album_pic.toString());
        fetched_songs.add(Local_Songs(
            foldername: key,
            songs: def,
            album_image: album_pic,
            status: value['status']));
      });
    });
    return fetched_songs;
  }

  List<FileSystemEntity> file = [];
  List<File>? song_file_list = [];
  String? file_name;
  File? image;



  Future getfilesong() async {
    image = null;
    String? imagePath='';
    String? foldername = '';

    List<Song_Module> mysongslist = [];
    // FilePickerResult? myresult = await FilePicker.platform.pickFiles(
    //   type: FileType.audio,
    //   allowMultiple: true,
    // );



    String? result2 = await FilePicker.platform.getDirectoryPath();
    print("alu arjun" + result2.toString());

    final title = result2!.split('/').last.split('(').first;
    print("title is " + title.toString());
    foldername = title;
    file = io.Directory(result2.toString()).listSync();
    print("gabbar" + file.toString());

    final List<String> selectedItems = [];

    for (final element in file) {
      print("element is " + element.toString());
      final String s =
          element.toString().substring(7, element.toString().length - 1);
      print("value of s is" + s.toString());
      selectedItems.add(s);
    }
    print("final list is " + selectedItems.toString());

    final purifiedSongsList = <String>[];

    for (final element in selectedItems) {
      final type = element.split('.');
      print(type[1]);
      if (type[1] == 'jpg' || type[1] == 'png') {
        imagePath = element;
      } else {
        purifiedSongsList.add(element);
      }
    }
    if (imagePath == null || imagePath.isEmpty) {
      print("honey");
imagePath="no_cover";
      print("baba" + image.toString());
    } else {
      print("sing");
      image = File(imagePath);
    }

    purifiedSongsList.forEach((myfile) {
      final _nameWithoutExtension = Path.basenameWithoutExtension(myfile);

      print("simran" + _nameWithoutExtension.toString());

      mysongslist.add(Song_Module(
          title: _nameWithoutExtension.toString(),
          Song_File_path: myfile,
          foldername: title));
    });

    if (mysongslist.length > 0) {
      var random = new Random();
      print("so image url is " + imagePath.toString());
      final songsBox = Hive.box('songs');
      await songsBox.put(foldername.toString(), {
        'status': true,
        'songs': mysongslist,
        'album_pic': imagePath
      }).then((value) {
        _foldername_controller.clear();
      });
    } else {
      // User canceled the picker
    }
  }


  // if (result2 != null) {
  //   print("name of file is " + myresult!.files.first.name.toString());
  //   file_name = myresult.files.first.name.toString();
  //   List<File> files = myresult.paths.map((path) => File(path!)).toList();
  //
  //   files.forEach((myfile) async {
  //
  //     final title = result2.split('/').last.split('(').first;
  //
  //     foldername=title;
  //     file = io.Directory(result2).listSync();
  //
  //     final List<String> selectedItems = [];
  //
  //     for (final element in file) {
  //       final String s =
  //           element.toString().substring(7, element.toString().length - 1);
  //       selectedItems.add(s);
  //
  //
  //     }
  //
  //     final purifiedSongsList = <String>[];
  //
  //     for (final element in selectedItems) {
  //
  //       final type = element.split('.');
  //       print(type[1]);
  //       if (type[1] == 'jpg' || type[1] == 'png') {
  //         imagePath = element;
  //       } else {
  //         purifiedSongsList.add(element);
  //       }
  //     }
  //
  //     image = File(imagePath!);
  //
  //
  //     final _nameWithoutExtension =
  //         Path.basenameWithoutExtension(myfile.path);
  //
  //     mysongslist.add(Song_Module(
  //       title: _nameWithoutExtension.toString(),
  //       Song_File_path: myfile.path,
  //       foldername: title
  //     ));
  //   });
  //
  //
  //
  //   if (mysongslist.length > 0) {
  //     var random = new Random();
  //
  //     final songsBox = Hive.box('songs');
  //     await songsBox.put(foldername.toString(), {
  //       'status': true,
  //       'songs': mysongslist,
  //       'album_pic': imagePath
  //     }).then((value) {
  //       _foldername_controller.clear();
  //     });
  //   }
  // } else {
  //   // User canceled the picker
  // }

  Box? songsBox;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _foldername_controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print("lund" + rmxAudioPlayer.isPlaying.toString());
    if (rmxAudioPlayer.isPlaying == true) {
      print("gashti" + rmxAudioPlayer.currentTrack.title.toString());
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFfff5f2),
        body: ListView(
          children: [
            ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                color: Colors.redAccent,
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_open,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text(
                          "Parent's Area",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Admin_Setting.routename);
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 30),
                          child: Icon(
                            Icons.settings,
                            color: Colors.black,
                            size: 30,
                          )),
                    )
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: fetch(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Local_Songs>> snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? SpinKitCircle(
                        color: Colors.black,
                      )
                    : snapshot.data!.length > 0
                        ? Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: height * 0.3,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.6,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              print('pressed');
                                            });
                                            int _song_index = 0;
                                            print("akbar");
                                            List<AudioTrack> new_list = [];
                                            snapshot.data![index].songs!
                                                .forEach((element) {
                                              new_list.add(
                                                  // Musics(title: element.title, image: element.image_path, singer: element.description, url: element.Song_File_path)
                                                  AudioTrack(
                                                      title: element.title,
                                                      assetUrl: element
                                                          .Song_File_path,
                                                      album: element.foldername,
                                                      artist: _song_index
                                                          .toString(),
                                                      trackId: _song_index
                                                          .toString(),
                                                      albumArt: snapshot
                                                          .data![index]
                                                          .album_image
                                                          .toString()));
                                              _song_index++;
                                            });

//
                                            print("song is " +
                                                new_list.toString());
                                            if (new_list.length > 0) {

                                              rmxAudioPlayer.isPlaying?
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Second_Parent_Play_Screen(
                                                          songs_list: new_list,
                                                          current_index: 0,
                                                          hive_index: index,
                                                          status: snapshot
                                                              .data![index]
                                                              .status,
                                                        )),
                                              ).then((value) {
                                                setState(() {});
                                              }):Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Play_Now_Screen(
                                                          songs_list: new_list,
                                                          current_index: 0,
                                                          play: false,
                                                          hive_index: index,
                                                          status: snapshot
                                                              .data![index]
                                                              .status,
                                                        )),
                                              ).then((value) {
                                                setState(() {});
                                              });


                                            } else {
                                              setState(() {
                                                print('album is empty');
                                              });
                                            }
                                          },
                                          child:

                                          snapshot.data![index]
                                              .album_image.toString()=="no_cover"?

                                          Container(
                                            height: height * 0.3,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:AssetImage("assets/images/no_cover.jpeg"))),
                                            width: width * 1,
                                          ): Container(
                                            height: height * 0.3,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:

                                                    FileImage(
                                                      File(snapshot.data![index]
                                                          .album_image
                                                          .toString()),
                                                    ))),
                                            width: width * 1,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          right: width * 0.03,
                                          top: height * 0.04,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2)),
                                            child: InkWell(
                                              onTap: () {
                                                final songsBox =
                                                    Hive.box('songs');
                                                print("Ali baba chalis chor " +
                                                    songsBox
                                                        .getAt(index)
                                                        .toString());
                                                songsBox.deleteAt(index);
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                          bottom: height * 0.02,
                                          left: width * 0.02,
                                          child: Container(
                                              height: height * 0.05,
                                              width: width * 0.4,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2)),
                                              child: Center(
                                                  child: Text(
                                                snapshot.data![index].foldername
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))))
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            height: height * 0.65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: Colors.grey)),
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Welcome to the Parents' Area!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ))),
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xffe9e1e8)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Now add a CD.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Divider(
                                          color: Color(0xffb8b3d0),
                                          thickness: height * 0.005,
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Text(
                                                "A cover image in the CD folder is automatically stored as an image."))
                                      ],
                                    )),
                              ],
                            ),
                          );
              },
            ),
          ],
        ),
        bottomNavigationBar: InkWell(
          onTap: () async {


            getfilesong().then((value) {
              setState(() {
                print("hello");
              });
            });
          },
          child: Container(
            height: height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xff5466c2),
            ),
            margin: EdgeInsets.only(
                left: width * 0.05, right: width * 0.05, bottom: height * 0.02),
            child: Center(
                child: Text(
              "Add Album",
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }
}

class BottomSlider extends StatefulWidget {
  @override
  State<BottomSlider> createState() => _BottomSliderState();
}

class _BottomSliderState extends State<BottomSlider> {
  void initState() {
    super.initState();
    void setState2(fn) {
      if (mounted) {
        print("step1");
        super.setState(fn);
      }
    }

    rmxAudioPlayer.on('status', (eventName, {dynamic args}) {
      print("ali jaanu" + eventName + (args ?? "").toString());
      rmxAudioPlayer.getPosition().then((value) {
        print("step5" + value.toString());
      });
      rmxAudioPlayer.getCurrentBuffer().then((value) {
        print("CurrentBuffer " + value.toString());

        if (mounted) {
          setState(() {
            double duration = value['duration'];
            double current_pos = value['currentPosition'];

            Provider.of<RMPlayer>(context, listen: false)
                .SetTotal(duration.toInt());
            // _total=duration.toInt();

            // _current =current_pos.toInt();
            Provider.of<RMPlayer>(context, listen: false)
                .SetCurrent(current_pos.toInt());

            // _status =value['status'].toString();
            Provider.of<RMPlayer>(context, listen: false)
                .SetStatus(value['status'].toString());

            if (Provider.of<RMPlayer>(context, listen: false).current > 0 &&
                Provider.of<RMPlayer>(context, listen: false).total > 0) {
              // _position = _current / _total;
              Provider.of<RMPlayer>(context, listen: false).Setposition(
                  (Provider.of<RMPlayer>(context, listen: false).current) /
                      (Provider.of<RMPlayer>(context, listen: false).total));
            } else if (!rmxAudioPlayer.isLoading && !rmxAudioPlayer.isSeeking) {
              Provider.of<RMPlayer>(context, listen: false).Setposition(0);
            }
            if (Provider.of<RMPlayer>(context, listen: false).seeking != null &&
                !rmxAudioPlayer.isSeeking &&
                !rmxAudioPlayer.isLoading) {
              // _seeking = null;
              Provider.of<RMPlayer>(context, listen: false).SetSeeking(null);
            }
          });
        }
      });
    });
  }

  _play() async {
    setState(() {});

    await rmxAudioPlayer.play();
  }

  _pause() {
    rmxAudioPlayer.pause().then((_) {
      print(_);
      setState(() {});
    }).catchError(print);
  }

  _onPressed() {
    if (rmxAudioPlayer.isLoading || rmxAudioPlayer.isSeeking) return null;

    if (rmxAudioPlayer.isPlaying) return _pause;

    return _play;
  }

  Widget _icon() {
    if (rmxAudioPlayer.isLoading || rmxAudioPlayer.isSeeking) {
      return const CircularProgressIndicator();
    }

    if (rmxAudioPlayer.isPlaying) {
      return const Icon(
        Icons.pause_circle_outline,
        size: 50,
        color: Colors.white,
      );
    }

    return const Icon(
      Icons.play_arrow,
      size: 50,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print("ali baba chalis chor");
    return Container(
      height: height * 0.135,
      color: Color(0xff5466c2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          rmxAudioPlayer.currentTrack.albumArt.toString()=="no_cover"?
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.108,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/no_cover.jpeg")
                // image: AssetImage('assets/images/preview.png')
              ),
            ),
          )
              :
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.108,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: FileImage(File(rmxAudioPlayer.currentTrack.albumArt))
                  // image: AssetImage('assets/images/preview.png')
                  ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: width * 0.05),
                    child: Text(
                      rmxAudioPlayer.currentTrack.title,
                      style: TextStyle(color: Colors.white),
                    )),
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Color(0xff7c86cf),
                  value: Provider.of<RMPlayer>(context, listen: false).position,
                  onChangeEnd: (val) async {
                    if (Provider.of<RMPlayer>(context, listen: false).total >
                        0) {
                      await rmxAudioPlayer.seekTo(val *
                          Provider.of<RMPlayer>(context, listen: false).total);
                    }
                  },
                  onChanged: (val) {
                    if (Provider.of<RMPlayer>(context, listen: false).total >
                        0) {
                      setState(() {
                        Provider.of<RMPlayer>(context, listen: false)
                            .SetSeeking(val);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.2,
              child: IconButton(
                onPressed: _onPressed(),
                icon: _icon(),
              ))
        ],
      ),
    );
  }
}
