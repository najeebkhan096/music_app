import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:music_app/Sign_in_Screen.dart';
import 'package:music_app/constants.dart';
import 'package:music_app/module/Local_Songs.dart';
import 'package:music_app/module/Song_module.dart';
import 'package:music_app/providers/rmplayer.dart';
import 'package:music_app/screens/child_play.dart';
import 'package:music_app/screens/second_child_play.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

class Library_Screen extends StatefulWidget {
  static const routename = 'Library_Screen';
  @override
  _Library_ScreenState createState() => _Library_ScreenState();
}

class _Library_ScreenState extends State<Library_Screen> {
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
        print(key + " key  " + value.toString());
        print("rimsha gashti " + value['status'].toString());

        if (value['status'] == true) {
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
          fetched_songs.add(
              Local_Songs(foldername: key, songs: def, album_image: album_pic));
        }
      });
    });
    bottomist = fetched_songs;
    return fetched_songs;
  }

  List<Local_Songs> bottomist = [];

  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print("pinkd gaal"+rmxAudioPlayer.isPlaying .toString());
    if (rmxAudioPlayer.isPlaying) {

      isPlaying = true;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFfff5f2),
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(Sign_in_Screen.routename);
            },
            child: Container(
                margin: EdgeInsets.only(left: width * 0.05),
                padding: EdgeInsets.all(3.5),
                child: Image.asset(
                  'assets/lock.png',
                  color: Color(0xffc7bfbd),
                )),
          ),
          elevation: 0,
          backgroundColor: Color(0xFFfff5f2),
          foregroundColor: Colors.black,
        ),
        // drawer: AppDrawer(),
        body: ListView(
          children: [
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
                            margin: EdgeInsets.only(
                                left: width * 0.05, right: width * 0.05),
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GridView.builder(
                              gridDelegate: MediaQuery.of(context)
                                          .orientation ==
                                      Orientation.landscape
                                  ? SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                    )
                                  : SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                    ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
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
                                              assetUrl: element.Song_File_path,
                                              album: element.foldername,
                                              artist: index.toString(),
                                              // artist: _song_index.toString(),
                                              trackId: _song_index.toString(),
                                              albumArt: snapshot
                                                  .data![index].album_image
                                                  .toString()));
                                      _song_index++;
                                    });

//
                                    print("song is " + new_list.toString());
                                    if (new_list.length > 0) {
                                      new_list.forEach((element) {
                                        print("usman" +
                                            element.trackId.toString());
                                      });

                                      rmxAudioPlayer.isPlaying
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Second_Child_Play(
                                                        current_index: 0,
                                                        hive_index: index,
                                                        songs_list: new_list,
                                                      )
                                                  // NowPlaying(mMusic: new_list,currentIndex: index,)
                                                  ),
                                            ).then((value) {
                                              setState(() {});
                                            }):

                                           Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Child_Play(
                                                        current_index: 0,
                                                        posotion: 0,
                                                        hive_index: index,
                                                        play: true,
                                                        songs_list: new_list,
                                                      )
                                                  // NowPlaying(mMusic: new_list,currentIndex: index,)
                                                  ),
                                            ).then((value) {
                                              setState(() {});
                                            });
                                    } else {
                                      setState(() {
                                        print('album is empty');
                                      });
                                    }
                                  },
                                  child: snapshot.data![index].album_image
                                              .toString() ==
                                          "no_cover"
                                      ? Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          color: Colors.black12,
                                          child: Container(
                                              height: height * 0.3,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/images/no_cover.jpeg")))))
                                      : Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          color: Colors.black12,
                                          child: Container(
                                              height: height * 0.3,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                        File(snapshot
                                                            .data![index]
                                                            .album_image
                                                            .toString()),
                                                      ))))),
                                );
                              },
                            ),
                          )
                        : Center(child: Text("No Data Added"));
              },
            ),
          ],
        ),
        bottomNavigationBar:
            isPlaying ? BottomSlider(mylist: bottomist) : Text(""),
      ),
    );
  }
}
int playFromPosition=0;
class BottomSlider extends StatefulWidget {
  final List<Local_Songs>? mylist;
  BottomSlider({this.mylist});
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
        print("CurrentBuffer " + value['duration'].toString());

        if (mounted) {
          print("gaand"+value['currentPosition'].toString());
          setState(() {

            double duration = value['duration'];
            double current_pos = value['currentPosition'];
            playFromPosition=current_pos.toInt();
            print("my pos"+playFromPosition.toString());

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

    return InkWell(
      onTap: () {
        int _song_index = 0;
        print("akbar");
        List<AudioTrack> new_list = [];
        print("value is " + rmxAudioPlayer.currentTrack.artist.toString());
        widget.mylist![int.parse(rmxAudioPlayer.currentTrack.artist.toString())]
            .songs!
            .forEach((element) {
          new_list.add(
              // Musics(title: element.title, image: element.image_path, singer: element.description, url: element.Song_File_path)
              AudioTrack(
                  title: element.title,
                  assetUrl: element.Song_File_path,
                  album: element.foldername,
                  artist: rmxAudioPlayer.currentTrack.artist.toString(),
                  // artist: _song_index.toString(),
                  trackId: _song_index.toString(),
                  albumArt: widget
                      .mylist![int.parse(rmxAudioPlayer.currentTrack.artist)]
                      .album_image
                      .toString()));
          _song_index++;
        });

//
        print("song is " + new_list.toString());
        if (new_list.length > 0) {
          new_list.forEach((element) {
            print("usman" + element.trackId.toString());
          });
          print("ariba "+playFromPosition.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Child_Play(
                  play: false,
                  posotion:  playFromPosition,
                      current_index:
                          int.parse(rmxAudioPlayer.currentTrack.trackId),
                      hive_index: int.parse(rmxAudioPlayer.currentTrack.artist),
                      songs_list: new_list,
                    )
                // NowPlaying(mMusic: new_list,currentIndex: index,)
                ),
          ).then((value) {
            setState(() {});
          });
        } else {
          setState(() {
            print('album is empty');
          });
        }
      },
      child: MediaQuery.of(context).orientation == Orientation.landscape
          ? Container(
              height: height * 0.3,
              color: Color(0xff5466c2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  rmxAudioPlayer.currentTrack.albumArt == "no_cover"
                      ? Container(
                          margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: height * 0.02,
                              bottom: height * 0.02),
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/no_cover.jpeg")),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: height * 0.02,
                              bottom: height * 0.02),
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(
                                    File(rmxAudioPlayer.currentTrack.albumArt))
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
                          value: Provider.of<RMPlayer>(context, listen: false)
                              .position,
                          onChangeEnd: (val) async {
                            if (Provider.of<RMPlayer>(context, listen: false)
                                    .total >
                                0) {
                              await rmxAudioPlayer.seekTo(val *
                                  Provider.of<RMPlayer>(context, listen: false)
                                      .total);
                            }
                          },
                          onChanged: (val) {
                            if (Provider.of<RMPlayer>(context, listen: false)
                                    .total >
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
            )
          : Container(
              height: height * 0.135,
              color: Color(0xff5466c2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  rmxAudioPlayer.currentTrack.albumArt == "no_cover"
                      ? Container(
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
                      : Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          height: MediaQuery.of(context).size.height * 0.108,
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(
                                    File(rmxAudioPlayer.currentTrack.albumArt))
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
                          value: Provider.of<RMPlayer>(context, listen: false)
                              .position,
                          onChangeEnd: (val) async {
                            if (Provider.of<RMPlayer>(context, listen: false)
                                    .total >
                                0) {
                              await rmxAudioPlayer.seekTo(val *
                                  Provider.of<RMPlayer>(context, listen: false)
                                      .total);
                            }
                          },
                          onChanged: (val) {
                            if (Provider.of<RMPlayer>(context, listen: false)
                                    .total >
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
            ),
    );
  }
}
