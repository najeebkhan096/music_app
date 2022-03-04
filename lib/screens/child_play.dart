import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:music_app/providers/rmplayer.dart';
import 'package:provider/provider.dart';
RmxAudioPlayer rmxAudioPlayer = new RmxAudioPlayer();

class Child_Play extends StatefulWidget {
  List<AudioTrack>? songs_list;
  int? current_index;
  int ? hive_index;
  int ? posotion;
  bool ? play;

  Child_Play({this.songs_list, this.current_index,this.hive_index,this.posotion,this.play});

  static const routename = "Child_Play";
  @override
  _Child_PlayState createState() => _Child_PlayState();
}

class _Child_PlayState extends State<Child_Play> {
  // double? _seeking;
  // double _position = 0;
  var iconHoverColor = const Color(0xFF065BC3);
  IconData btnIcon = Icons.play_arrow;
  // int _current = 0;
  //
  // int _total = 0;

  // String _status = 'none';
  int current_song_index=0;
  @override
  void initState() {

    super.initState();
    void setState(fn) {
      if (mounted) {
        print("step1");
        super.setState(fn);
      }
    }
     _prepare();
    rmxAudioPlayer.initialize();
    if(widget.play==true){

    }
    else{
      rmxAudioPlayer
          .playTrackById(widget.songs_list![widget.current_index!].trackId,position: widget.posotion);

    }

    rmxAudioPlayer.on('status', (eventName, {dynamic args}) {

      rmxAudioPlayer.getPosition().then((value) {
        print("step5"+ value.toString());
      });
      rmxAudioPlayer.getCurrentBuffer().then((value) {
        print("CurrentBuffer "+ value.toString());

       if(mounted){
         setState((){
           double duration=value['duration'];
           double current_pos=value['currentPosition'];

           Provider.of<RMPlayer>(context,listen: false).SetTotal(duration.toInt());
           // _total=duration.toInt();

           // _current =current_pos.toInt();
           Provider.of<RMPlayer>(context,listen: false).SetCurrent(current_pos.toInt());

           // _status =value['status'].toString();
           Provider.of<RMPlayer>(context,listen: false).SetStatus(value['status'].toString());


           if (Provider.of<RMPlayer>(context,listen: false).current > 0 && Provider.of<RMPlayer>(context,listen: false).total > 0) {
             // _position = _current / _total;
             Provider.of<RMPlayer>(context,listen: false).Setposition((Provider.of<RMPlayer>(context,listen: false).current)/ (Provider.of<RMPlayer>(context,listen: false).total));
           } else if (!rmxAudioPlayer.isLoading && !rmxAudioPlayer.isSeeking) {
             Provider.of<RMPlayer>(context,listen: false).Setposition(0);
           }
           if (Provider.of<RMPlayer>(context,listen: false).seeking != null &&
               !rmxAudioPlayer.isSeeking &&
               !rmxAudioPlayer.isLoading) {
             // _seeking = null;
             Provider.of<RMPlayer>(context,listen: false).SetSeeking(null);
           }

         });

       }


        });

    });

  }

  _prepare() async {
    print("gandhi"+widget.posotion.toString());
    if(widget.play==false){
      await rmxAudioPlayer.setPlaylistItems(
          widget.songs_list,
          options: new PlaylistItemOptions(
            startPaused: false,
            playFromPosition: widget.posotion,
            playFromId: widget.current_index.toString(),
          )).then((value) async{

      });
    }
    else{
      await rmxAudioPlayer.setPlaylistItems(
          widget.songs_list,
          options: new PlaylistItemOptions(
            startPaused: true,
            playFromPosition: widget.posotion,
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
    print("step rebuild");
    return Scaffold(
      backgroundColor: Color(0xFFfff5f2),
      body: _body(),
    );
  }

  Widget _body() {
    if (Provider.of<RMPlayer>(context,listen: false).status == 'none' || Provider.of<RMPlayer>(context,listen: false).status == 'stopped') {
      return Center(child: _actionPrepare());
    }

    return

      MediaQuery.of(context).orientation ==
          Orientation.landscape?
      _landscape():
      _Myplayer()
    ;
  }

  Widget _actionPrepare() {
    return RaisedButton(
      child:  Image.asset('assets/images/Group 42.png'),
      onPressed: _prepare,
    );
  }


  Widget _landscape() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        children: [

          //

          Row(
            children: <Widget>[
              Container(
                height: height*1,
                width: width*0.45,

                child: Column(
                  children: [
                    SizedBox(
                      height: height*0.05,
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
                        )
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
                padding: EdgeInsets.only(top: height*0.03),
                height: height*1,
                width: width*0.55,
                color: Color(0xff5466c2),
                child: ListView(
                  children: [

                  Column(
                    children: List.generate(widget.songs_list!.length, (index) => ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        onTap: () async {
                          rmxAudioPlayer.playTrackByIndex(index);

                          setState(() {
                            current_song_index=index;
                          });


                        },
                        leading:
                        rmxAudioPlayer.currentTrack.trackId==index.toString()?
                        Container(
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
                            )):
                        Container(
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
                            )),
                        title:
                        rmxAudioPlayer.currentTrack.trackId==index.toString()?
                        Text(
                          widget.songs_list![index].title.toString(),
                          style: TextStyle(color: Colors.red),
                        ): Text(
                          widget.songs_list![index].title.toString(),
                          style: TextStyle(color: Colors.white),
                        )
                    ),),
                  ),


                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Divider(color: Colors.white,),
                    Slider(
                      activeColor: Colors.white,
                      inactiveColor: Color(0xff7c86cf),
                      value: Provider.of<RMPlayer>(context,listen: false).position,
                      onChangeEnd: (val) async {
                        if (Provider.of<RMPlayer>(context,listen: false).total > 0) {
                          await rmxAudioPlayer.seekTo(val * Provider.of<RMPlayer>(context,listen: false).total);
                        }
                      },
                      onChanged: (val) {
                        if (Provider.of<RMPlayer>(context,listen: false).total > 0) {
                          setState(() {
                            Provider.of<RMPlayer>(context,listen: false).SetSeeking(val);
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
                            _format(Provider.of<RMPlayer>(context,listen: false).current),
                            style: TextStyle(color: Colors.white),
                          ),
                          new Text(
                            _format(Provider.of<RMPlayer>(context,listen: false).total),
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
                  value: Provider.of<RMPlayer>(context,listen: false).position,
                  onChangeEnd: (val) async {
                    if (Provider.of<RMPlayer>(context,listen: false).total > 0) {
                      await rmxAudioPlayer.seekTo(val * Provider.of<RMPlayer>(context,listen: false).total);
                    }
                  },
                  onChanged: (val) {
                    if (Provider.of<RMPlayer>(context,listen: false).total > 0) {
                      setState(() {
                        Provider.of<RMPlayer>(context,listen: false).SetSeeking(val);
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
                        _format(Provider.of<RMPlayer>(context,listen: false).current),
                        style: TextStyle(color: Colors.white),
                      ),
                      new Text(
                        _format(Provider.of<RMPlayer>(context,listen: false).total),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

Column(
  children:  List.generate(widget.songs_list!.length,(index){
    return  ListTile(
        contentPadding: EdgeInsets.only(left: 20),
        onTap: () async {
          rmxAudioPlayer.playTrackByIndex(index);

          setState(() {
            current_song_index=index;
          });


        },
        leading:
        rmxAudioPlayer.currentTrack.trackId==index.toString()?
        Container(
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
            )):
        Container(
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
            )),
        title:
        rmxAudioPlayer.currentTrack.trackId==index.toString()?
        Text(
          widget.songs_list![index].title.toString(),
          style: TextStyle(color: Colors.red),
        ): Text(
          widget.songs_list![index].title.toString(),
          style: TextStyle(color: Colors.white),
        )
    );
  }),
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
}