import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/module/Song_module.dart';

RmxAudioPlayer rmxAudioPlayer = new RmxAudioPlayer();

class Play_Now_Screen extends StatefulWidget {
  List<AudioTrack>? songs_list;
  int? current_index;
  int? hive_index;
  bool ? status;
  bool ? play ;
  Play_Now_Screen({this.songs_list, this.current_index, this.hive_index,this.status,this.play});

  static const routename = "Play_Now_Screen";
  @override
  _Play_Now_ScreenState createState() => _Play_Now_ScreenState();
}

class _Play_Now_ScreenState extends State<Play_Now_Screen> {
  double? _seeking;
  double _position = 0;
  var iconHoverColor = const Color(0xFF065BC3);
  IconData btnIcon = Icons.play_arrow;
  int _current = 0;
  int current_song_index = 0;
  int _total = 0;

  String _status = 'none';

  @override
  void initState() {
    super.initState();

    void setState(fn) {
      if (mounted) {
        super.setState(fn);
      }
    }

    _prepare();
    rmxAudioPlayer.initialize();
    if(widget.play==true){

    }
    else{
      rmxAudioPlayer
          .playTrackById(widget.songs_list![widget.current_index!].trackId);

    }

    // rmxAudioPlayer
    //     .playTrackById(widget.songs_list![widget.current_index!].trackId);
    rmxAudioPlayer.on('status', (eventName, {dynamic args}) {
      print(eventName + (args ?? "").toString());

      if ((args as OnStatusCallbackData).value != null) {
        setState(() {
          if ((args as OnStatusCallbackData).value['currentPosition'] != null) {
            _current =
                (args as OnStatusCallbackData).value['currentPosition'].toInt();
            _total = (((args as OnStatusCallbackData).value['duration']) ?? 0)
                .toInt();
            _status = (args as OnStatusCallbackData).value['status'];

            if (_current > 0 && _total > 0) {
              _position = _current / _total;
            } else if (!rmxAudioPlayer.isLoading && !rmxAudioPlayer.isSeeking) {
              _position = 0;
            }

            if (_seeking != null &&
                !rmxAudioPlayer.isSeeking &&
                !rmxAudioPlayer.isLoading) {
              _seeking = null;
            }
          }
        });
      }
    });

  }




  _prepare() async {

    if(widget.play==false){
      await rmxAudioPlayer.setPlaylistItems(
          widget.songs_list,
          options: new PlaylistItemOptions(
            startPaused: false,
            playFromId: widget.current_index.toString(),
          )).then((value) async{

      });
    }
    else{
      await rmxAudioPlayer.setPlaylistItems(
          widget.songs_list,
          options: new PlaylistItemOptions(
            startPaused: true,
            playFromId: widget.current_index.toString(),
          )).then((value) async{
        await _pause();
      });
    }

    await rmxAudioPlayer.setLoop(true);

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

  @override
  Widget build(BuildContext context) {
    print("ABCdee  song"+widget.current_index.toString());
    print("DEF"+current_song_index.toString());
    print("arjun"+rmxAudioPlayer.currentTrack.trackId.toString());
    return Scaffold(
      backgroundColor: Color(0xFFfff5f2),
      body: _body(),
    );
  }

  Widget _body() {
    if (_status == 'none' || _status == 'stopped') {
      return Center(child: _actionPrepare());
    }

    return

      MediaQuery.of(context).orientation ==
          Orientation.landscape?
          _landscape():
          _Myplayer()
    ;
  }
  Widget _landscape() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        children: [

          SizedBox(
            height: height*0.02,
          ),
          //

          Row(
            children: <Widget>[
              Container(
                height: height*1,
                width: width*0.45,

                 child: Column(
                   children: [
                     SizedBox(
                       height: height*0.1,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         InkWell(
                             onTap: (){
                               Navigator.of(context).pop();
                             },
                             child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 40,)),
                         InkWell(
                           onTap: (){
                             Navigator.of(context).pop();
                           },
                           child: Container(
                               width: MediaQuery.of(context).size.width*0.25,
                               padding: EdgeInsets.only(top: 5,bottom: 5),
                               decoration: BoxDecoration(
                                   border: Border.all(color: Colors.black,width: 2),
                                   borderRadius: BorderRadius.circular(10)
                               ),

                               child: Center(child: Text("Back",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,))),
                         ),
                         InkWell(

                             onTap: ()async{
                               bool curr_status=widget.status!;
                               print("status value is "+widget.status.toString());
                               await Hive.openBox('songs').then((value) {
                                 final songsBox = Hive.box('songs');


                                 List<Song_Module> mysongslist = [];
                                 widget.songs_list!.forEach((element) {
                                   mysongslist.add(Song_Module(
                                       foldername: element.album,
                                       image_path: element.albumArt,
                                       title: element.title,
                                       description: '',
                                       song_index: element.artist,
                                       Song_File_path:element.assetUrl
                                   ));
                                 });


                                 songsBox
                                     .put(rmxAudioPlayer.currentTrack.album, {
                                   'status': !curr_status,
                                   'songs': mysongslist,
                                   'album_pic': rmxAudioPlayer.currentTrack.albumArt
                                 });

                                 print("curre statues"+curr_status.toString());
                                 widget.status=!curr_status;
                                 print("after changing statues"+widget.status.toString());
                                 setState(() {

                                 });
                               });
                             },
                             child: widget.status!?Icon(Icons.remove_red_eye,color: Colors.black,size: 40,):

                             Icon(Icons.visibility_off,color: Colors.black,size: 40,))
                         ,
                       ],
                     ),

                     SizedBox(
                       height: height*0.05,
                     ),
                     //Now we will create Album Art Disk

                     rmxAudioPlayer.currentTrack.albumArt=="no_cover"?
                     Container(
                       margin: EdgeInsets.only(left: 10, right: 10),
                       height: MediaQuery.of(context).size.height * 0.4,
                       width: MediaQuery.of(context).size.width * 1,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                         image: DecorationImage(
                             fit: BoxFit.fill,
                             image: AssetImage("assets/images/no_cover.jpeg")
                           // image: AssetImage('assets/images/preview.png')
                         ),
                       ),
                     ):
                     Container(
                       margin: EdgeInsets.only(left: 10, right: 10),
                       height: MediaQuery.of(context).size.height * 0.4,
                       width: MediaQuery.of(context).size.width * 1,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(20),
                         image: DecorationImage(
                             fit: BoxFit.fill,
                             image: FileImage(File(rmxAudioPlayer.currentTrack.albumArt))
                           // image: AssetImage('assets/images/preview.png')
                         ),
                       ),
                     ),

                     SizedBox(
                       height: height*0.05,
                     ),

                     Container(

                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: <Widget>[
                           //The buttons are called passing its above symbol
                           InkWell(
                               onTap: rmxAudioPlayer.skipBack,
                               child: Icon(
                                 FontAwesomeIcons.backward,
                                 size: 30,
                               )),
                           SizedBox(
                             width: width*0.02,
                           ),

                           Container(
                             height: MediaQuery.of(context).size.height * 0.15,
                             width: MediaQuery.of(context).size.width * 0.25,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(25),
                               color: Color(0xff5466c2),
                             ),
                             child: IconButton(
                               onPressed: _onPressed(),
                               icon: _icon(),
                             ),
                           ),
                           SizedBox(
                             width: width*0.02,
                           ),
                           InkWell(
                               onTap: rmxAudioPlayer.skipForward,
                               child: Icon(
                                 FontAwesomeIcons.forward,
                                 size: 30,
                               )),
                         ],
                       ),
                     ),


                   ],
                 ),
              ),
              Container(
                padding: EdgeInsets.only(top: height*0.1),
                height: height*1,
                width: width*0.55,
                color: Color(0xff5466c2),
        child: ListView(
          children: [

            Column(
              children: List.generate(widget.songs_list!.length, (index) =>   ListTile(
                contentPadding: EdgeInsets.only(left: 20),
                onTap: () async {
                  rmxAudioPlayer.playTrackByIndex(index);

                  setState(() {
                    current_song_index = index;
                  });

                },
                trailing: Container(
                  margin: EdgeInsets.only(right: 20),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white, width: 2)),
                  child: InkWell(

                    onTap: () async {

                      List<Song_Module> mysongslist = [];
                      widget.songs_list!.forEach((element) {
                        mysongslist.add(Song_Module(
                            foldername: element.album,
                            image_path: element.albumArt,
                            title: element.title,
                            description: '',
                            song_index: element.artist,
                            Song_File_path:element.assetUrl
                        ));
                      });

                      await Hive.openBox('songs').then((value) {
                        final songsBox = Hive.box('songs');
                        widget.songs_list!.removeAt(index);
                        mysongslist.removeAt(index);

                        songsBox
                            .put(rmxAudioPlayer.currentTrack.album, {
                          'status': true,
                          'songs': mysongslist,
                          'album_pic': rmxAudioPlayer.currentTrack.albumArt
                        });


                        setState(() {});

                      });

                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                leading: rmxAudioPlayer.currentTrack.artist ==
                    index.toString()
                    ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                          color: Colors.red, width: 2.7),
                    ),
                    padding: EdgeInsets.only(
                        left: 8, right: 8, top: 3, bottom: 3),
                    child: Text(
                      0.toString() + (index + 1).toString(),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ))
                    : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                        color: Colors.white, width: 2.7),
                  ),
                  padding: EdgeInsets.only(
                      left: 8, right: 8, top: 3, bottom: 3),
                  child: Text(
                    0.toString() + (index + 1).toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),

                ),
                title: rmxAudioPlayer.currentTrack.artist ==
                    index.toString()
                    ? Text(
                  widget.songs_list![index].title
                      .toString(),
                  style: TextStyle(color: Colors.red),
                )
                    : Text(
                  widget.songs_list![index].title
                      .toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),),
            ),




            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Divider(color: Colors.white,),
            Container(
              color: Color(0xff5466c2),
              child: Column(
                children: [
                  Slider(
                    activeColor: Colors.white,
                    inactiveColor: Color(0xff7c86cf),
                    value: _seeking ?? _position,
                    onChangeEnd: (val) async {
                      if (_total > 0) {
                        await rmxAudioPlayer.seekTo(val * _total);
                      }
                    },
                    onChanged: (val) {
                      if (_total > 0) {
                        setState(() {
                          _seeking = val;
                        });
                      }
                    },
                  ),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    _format(_current),
                    style: TextStyle(color: Colors.white),
                  ),
                  new Text(
                    _format(_total),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
              ),

              //




            ],
          ),
        ],
      ),
    );
  }


  Widget _actionPrepare() {
    return RaisedButton(
      child:  Image.asset('assets/images/Group 42.png'),
      onPressed: _prepare,
    );
  }

  Widget _Myplayer() {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    InkWell(
        onTap: (){
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 40,)),
    InkWell(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Container(
          width: MediaQuery.of(context).size.width*0.6,
          padding: EdgeInsets.only(top: 5,bottom: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black,width: 2),
              borderRadius: BorderRadius.circular(10)
          ),

          child: Center(child: Text("Back",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,))),
    ),
    InkWell(

        onTap: ()async{
bool curr_status=widget.status!;
print("status value is "+widget.status.toString());
          await Hive.openBox('songs').then((value) {
            final songsBox = Hive.box('songs');


            List<Song_Module> mysongslist = [];
            widget.songs_list!.forEach((element) {
              mysongslist.add(Song_Module(
                  foldername: element.album,
                  image_path: element.albumArt,
                  title: element.title,
                  description: '',
                  song_index: element.artist,
                  Song_File_path:element.assetUrl
              ));
            });


            songsBox
                .put(rmxAudioPlayer.currentTrack.album, {
              'status': !curr_status,
              'songs': mysongslist,
              'album_pic': rmxAudioPlayer.currentTrack.albumArt
            });

print("curre statues"+curr_status.toString());
widget.status=!curr_status;
            print("after changing statues"+widget.status.toString());
setState(() {

});
          });
        },
        child: widget.status!?Icon(Icons.remove_red_eye,color: Colors.black,size: 40,):

    Icon(Icons.visibility_off,color: Colors.black,size: 40,))
    ,
  ],
),

          SizedBox(
            height: 30,
          ),


          //Now we will create Album Art Disk
          rmxAudioPlayer.currentTrack.albumArt=="no_cover"?
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/no_cover.jpeg")
                // image: AssetImage('assets/images/preview.png')
              ),
            ),
          ):
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: FileImage(File(rmxAudioPlayer.currentTrack.albumArt))
                // image: AssetImage('assets/images/preview.png')
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),


          SizedBox(
            height: 20,
          ),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //The buttons are called passing its above symbol
                InkWell(
                    onTap: rmxAudioPlayer.skipBack,
                    child: Icon(
                      FontAwesomeIcons.backward,
                      size: 30,
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xff5466c2),
                  ),
                  child: IconButton(
                    onPressed: _onPressed(),
                    icon: _icon(),
                  ),
                ),

                InkWell(
                    onTap: rmxAudioPlayer.skipForward,
                    child: Icon(
                      FontAwesomeIcons.forward,
                      size: 30,
                    )),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

          Container(
            color: Color(0xff5466c2),
            child: Column(
              children: [
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Color(0xff7c86cf),
                  value: _seeking ?? _position,
                  onChangeEnd: (val) async {
                    if (_total > 0) {
                      await rmxAudioPlayer.seekTo(val * _total);
                    }
                  },
                  onChanged: (val) {
                    if (_total > 0) {
                      setState(() {
                        _seeking = val;
                      });
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        _format(_current),
                        style: TextStyle(color: Colors.white),
                      ),
                      new Text(
                        _format(_total),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: List.generate(widget.songs_list!.length, (index) =>         ListTile(
                    contentPadding: EdgeInsets.only(left: 20),
                    onTap: () async {
                      rmxAudioPlayer.playTrackByIndex(index);

                      setState(() {
                        current_song_index = index;
                      });

                    },
                    trailing: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white, width: 2)),
                      child: InkWell(

                        onTap: () async {

                          List<Song_Module> mysongslist = [];
                          widget.songs_list!.forEach((element) {
                            mysongslist.add(Song_Module(
                                foldername: element.album,
                                image_path: element.albumArt,
                                title: element.title,
                                description: '',
                                song_index: element.artist,
                                Song_File_path:element.assetUrl
                            ));
                          });

                          await Hive.openBox('songs').then((value) {
                            final songsBox = Hive.box('songs');
                            widget.songs_list!.removeAt(index);
                            mysongslist.removeAt(index);

                            songsBox
                                .put(rmxAudioPlayer.currentTrack.album, {
                              'status': true,
                              'songs': mysongslist,
                              'album_pic': rmxAudioPlayer.currentTrack.albumArt
                            });


                            setState(() {});

                          });

                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    leading: rmxAudioPlayer.currentTrack.artist ==
                        index.toString()
                        ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                              color: Colors.red, width: 2.7),
                        ),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 3, bottom: 3),
                        child: Text(
                          0.toString() + (index + 1).toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ))
                        : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: Colors.white, width: 2.7),
                      ),
                      padding: EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 3),
                      child: Text(
                        0.toString() + (index + 1).toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),

                    ),
                    title: rmxAudioPlayer.currentTrack.artist ==
                        index.toString()
                        ? Text(
                      widget.songs_list![index].title
                          .toString(),
                      style: TextStyle(color: Colors.red),
                    )
                        : Text(
                      widget.songs_list![index].title
                          .toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  String _format(int secs) {
    int sec = secs;

    int min = 0;
    if (secs > 60) {
      min = (sec / 60).floor();
      sec = sec % 60;
    }

    return (min >= 10 ? min.toString() : '0' + min.toString()) +
        ":" +
        (sec >= 10 ? sec.toString() : '0' + sec.toString());
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
        size: 40,
        color: Colors.white,
      );
    }

    return const Icon(
      Icons.play_arrow,
      size: 45,
      color: Colors.white,
    );
  }
}
