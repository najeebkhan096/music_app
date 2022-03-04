import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/constants.dart';
import 'package:music_app/providers/rmplayer.dart';
import 'package:music_app/screens/child_play.dart';
import 'package:provider/provider.dart';



class Second_Child_Play extends StatefulWidget {
  List<AudioTrack>? songs_list;
  int? current_index;
  int? hive_index;
  Second_Child_Play({this.songs_list, this.current_index, this.hive_index});
  static const routename = "Second_Child_Play";
  @override
  _Second_Child_PlayState createState() => _Second_Child_PlayState();
}

class _Second_Child_PlayState extends State<Second_Child_Play> {
  // double? _seeking;
  // double _position = 0;
  var iconHoverColor = const Color(0xFF065BC3);
  IconData btnIcon = Icons.play_arrow;
  // int _current = 0;
  //
  // int _total = 0;

  // String _status = 'none';
  int current_song_index = 0;
  @override



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfff5f2),
      body: _body(),
    );
  }

  Widget _body() {


    return MediaQuery.of(context).orientation == Orientation.landscape
        ? _landscape()
        : _Myplayer();
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
                height: height * 1,
                width: width * 0.45,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 40,
                            )),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "Back",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ))),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: height * 0.05,
                    ),
                    //Now we will create Album Art Disk
                    widget.songs_list![widget.current_index!].albumArt == "no_cover"
                        ? Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage("assets/images/no_cover.jpeg")
                                  // image: AssetImage('assets/images/preview.png')
                                  ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(File(widget.songs_list![widget.current_index!].albumArt))
                                  // image: AssetImage('assets/images/preview.png')
                                  ),
                            ),
                          ),

                    SizedBox(
                      height: height * 0.05,
                    ),

                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //The buttons are called passing its above symbol
                          InkWell(
                              onTap: (){},
                              child: Icon(
                                FontAwesomeIcons.backward,
                                size: 30,
                              )),
                          SizedBox(
                            width: width * 0.02,
                          ),

                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xff5466c2),
                            ),
                            child: IconButton(
                              onPressed: (){},
                              icon: _icon(),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          InkWell(
                              onTap: (){

                              },
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
                padding: EdgeInsets.only(top: height * 0.03),
                height: height * 1,
                width: width * 0.55,
                color: Color(0xff5466c2),
                child: ListView(
                  children: [
                    Column(
                      children: List.generate(
                        widget.songs_list!.length,
                        (index) => ListTile(
                            contentPadding: EdgeInsets.only(left: 20),
                            onTap: () async {
print("semeee");
Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context) =>
          Child_Play(
            current_index: index,
            hive_index: widget.hive_index,
            songs_list: widget.songs_list,
          )
    // NowPlaying(mMusic: new_list,currentIndex: index,)
  ),
).then((value) {
  Navigator.of(context).pop();
});
                            },
                            leading:widget.songs_list![widget.current_index!].trackId ==
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
                                    )),
                            title: widget.songs_list![widget.current_index!].trackId ==
                                    index.toString()
                                ? Text(
                                    widget.songs_list![index].title.toString(),
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text(
                                    widget.songs_list![index].title.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Slider(
                      activeColor: Colors.white,
                      inactiveColor: Color(0xff7c86cf),
                      value:0,
                      onChangeEnd: (val) async {

                      },
                      onChanged: (val) {

                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text("0:00",
                            style: TextStyle(color: Colors.white),
                          ),
                          new Text("0:00",
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
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 40,
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Back",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          //Now we will create Album Art Disk
          widget.songs_list![widget.current_index!].albumArt== "no_cover"
              ? Container(
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
                )
              : Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(
                            File(widget.songs_list![widget.current_index!].albumArt))
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
                    onTap:(){},
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
                    onPressed: (){

                    },
                    icon: _icon(),
                  ),
                ),

                InkWell(
                    onTap: (){

                    },
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
                  value: 0,
                  onChangeEnd: (val) async {

                  },
                  onChanged: (val) {

                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text("00:00",
                        style: TextStyle(color: Colors.white),
                      ),
                      new Text(
                      "00:00",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(widget.songs_list!.length, (index) {
                    return ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        onTap: () async {

Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context) =>
          Child_Play(
            current_index: index,
            hive_index: widget.hive_index,
            songs_list: widget.songs_list,
          )
    // NowPlaying(mMusic: new_list,currentIndex: index,)
  ),
).then((value) {
  Navigator.of(context).pop();
});
                        },
                        leading: widget.songs_list![widget.current_index!].trackId ==
                                index.toString()
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border:
                                      Border.all(color: Colors.red, width: 2.7),
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
                                )),
                        title: widget.songs_list![widget.current_index!].trackId ==
                                index.toString()
                            ? Text(
                                widget.songs_list![index].title.toString(),
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                widget.songs_list![index].title.toString(),
                                style: TextStyle(color: Colors.white),
                              ));
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _icon() {




    return const Icon(
      Icons.play_arrow,
      size: 50,
      color: Colors.white,
    );
  }
}
