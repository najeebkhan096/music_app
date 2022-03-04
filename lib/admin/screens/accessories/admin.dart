import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_app/library.dart';
import 'package:music_app/module/Song_module.dart';
import 'package:music_app/Sign_in_Screen.dart';
import 'package:music_app/admin/screens/accessories/add_song.dart';
import 'package:music_app/admin/screens/accessories/delete_song.dart';
import 'package:music_app/admin/screens/accessories/Parent_view.dart';
class Admin extends StatefulWidget {

  static const routename="Admin";
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {



  List<Song_Module> CD1 = [
    Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Phonics_Song.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC'),
    Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Song_Train.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC')
   , Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Abc2_Alphabet2.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC'),
    Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Alphabet2.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC')
    ,Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Five_Little_Monkeys_Jumping_on_the_Bed.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC'),
    Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Frog_Song.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC')
    ,Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Knees_Toes.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC'),
    Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Lower_Case_ABC.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC')
    ,Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/The_Alphabet_Lower_Case.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC'),
    Song_Module(foldername:'CD1' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Upper_Case_Only.mp3',song_index:0 ,description:'alphabetic' ,title: 'ABC')


  ];

  List<Song_Module> CD2 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Alphabet.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
    ,Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Alphabet_Read',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
    ,Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Head_Shoulders.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];

  List<Song_Module> CD3 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Alphabet.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
    ,Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Alphabet_Song.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];
  List<Song_Module> CD4 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_AlphabetReadAlong.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
,    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/The_Alphabet_Song_Lower_Case_ABC_songs.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)



  ];
  List<Song_Module> CD5 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Alphabet_Read_Along.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
, Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Alphabet_Read_Along.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];
  List<Song_Module> CD6 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Along.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
, Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/songs.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];
  List<Song_Module> CD7 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Alphabet_Lower.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
, Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Alphabet_Read_Along.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];
  List<Song_Module> CD8 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_Alpha.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
, Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/Lower_Case_ABC.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];
  List<Song_Module> CD9 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_along.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
, Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/low_alphabet.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];
  List<Song_Module> CD10 = [
    Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)
, Song_Module(foldername:'CD2' ,image_path:'assets/Song title Cover - to change the title Image - yellow.jpg' ,Song_File_path: 'asset://assets/ABC_low.mp3',song_index:0 ,description:'alphabetic' ,title: 'Head Shoulders',)

  ];


  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFB98959),
      appBar: AppBar(
        title: Text('Parent',style: TextStyle(color: Colors.white,fontSize: 25),),
        elevation: 0,
        backgroundColor: Color(0xFFB98959),
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 20),
          child: InkWell(
              onTap: () async {
        Navigator.of(context).pushReplacementNamed(Sign_in_Screen.routename);
              },
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white,fontSize: 20),
              )),
        )
      ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height*1,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                InkWell(
                  onTap: (){
Navigator.of(context).pushNamed(Add_Song.routename);
                  },
                  child: Card(
                    elevation: 10,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 12),
                      height: MediaQuery.of(context).size.height*0.3,
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Column(
                        children: [
                          Container(height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.height*1,
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset('assets/images/music1.jfif'))),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          Container(

                              height: MediaQuery.of(context).size.height*0.05,
                              child: Text("Add song",textAlign: TextAlign.center,))
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed(Library_Screen.routename);
                  },
                  child: Card(
                    elevation: 10,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 12),
                      height: MediaQuery.of(context).size.height*0.3,
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height*0.21,
                              width: MediaQuery.of(context).size.height*1,
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset('assets/images/music2.jpg'))),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          Container(

                              height: MediaQuery.of(context).size.height*0.05,
                              child: Text("View song",textAlign: TextAlign.center,))
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed(Delete_Song.routename);
                  },
                  child: Card(
                    elevation: 10,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 12),
                      height: MediaQuery.of(context).size.height*0.3,
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.height*1,
                              height: MediaQuery.of(context).size.height*0.2,
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset('assets/images/music3.jpg'))),
                          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          Container(

                              height: MediaQuery.of(context).size.height*0.05,
                              child: Text("Delete song",textAlign: TextAlign.center,),)
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),


              ],
            ),

          ],
        ),
      ),
    );
  }
}
