import 'dart:io';
import 'package:music_app/module/Song_module.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart' as Path;

class Add_Song extends StatefulWidget {
  static const routename = "Add_Song";

  @override
  _Add_SongState createState() => _Add_SongState();
}

class _Add_SongState extends State<Add_Song> {
  File? image_file;
  List<File>? song_file_list=[];
  String ? file_name;
  File? file;
  bool ispressed = false;
  bool uploading = false;
  String? title;
  String? desc;

  double? rental;

  double val = 0;

  bool isloading = false;

  List<String> songs_folders = ['CD 1', 'CD 2', 'CD 3','CD 4','CD 5','CD 6','CD 7','CD 8','CD 9','CD 10'];
  String select_folder = '';

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      add_data().then((value) {
        Navigator.of(context).pop();
      });
      setState(() {
        isloading = true;
      });
    } catch (error) {}
  }




  Future add_data() async {

    final songsBox=Hive.box('songs');
    songsBox.add(Song_Module(
        description: desc,
        title: file_name,
        image_path: image_file!.path,
        foldername: select_folder,
        Song_File_path: song_file_list!.first.path,
    ) );


  }

  Future getimage_file() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      setState(() {
        image_file = files.first;
      });
    } else {
      // User canceled the picker
    }
  }

  Future getfilesong() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      print("name of file is "+result.files.first.name.toString());
      file_name=result.files.first.name.toString();
      List<File> files = result.paths.map((path) => File(path!)).toList();
      files.forEach((myfile) {
        setState(() {
          song_file_list!.add(myfile);
        });

      });
    } else {
      // User canceled the picker
    }
  }

  String? _showErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Error Accured'),
              content: Text("Please Select an Image"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     Hive.openBox('songs');

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
backgroundColor: Color(0xFFB98959),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Add Song",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFFB98959),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//imagepicker
                  if (image_file != null)
                    Container(
                      margin: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          image: DecorationImage(
                              fit: BoxFit.fill, image: FileImage(image_file!)),
                          borderRadius: BorderRadius.circular(30)),
                      width: MediaQuery.of(context).size.width * 0.9,
                    )
                  else
                    InkWell(
                      onTap: getimage_file,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Text(
                          "Select Song Image",
                          style: TextStyle(fontSize: 20,color: Colors.white),
                        )),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //songs picker


      song_file_list!.isEmpty?InkWell(
        onTap: getfilesong,
        child: Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(30)),
          child: Center(
              child: Text(
                "Select Song File",
                style: TextStyle(fontSize: 20,color: Colors.white),
              )),
        ),
      ):
                    Container(

                      height: MediaQuery.of(context).size.height * 0.12,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width * 0.9,
                          child: Center(child: Text(file_name.toString(),style: TextStyle(color: Colors.white),)),
                          );
                        },
                        itemCount: song_file_list!.length,
                      ),
                    ),






                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    margin: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.4),
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(6)),
                    padding: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Write Singer name",
                        hintStyle: TextStyle(color: Colors.white),
                        helperStyle: TextStyle(color:Colors.white)
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'invalid';
                        }
                      },
                      onSaved: (value) {
                        desc = value;
                      },
                    ),
                  ),



                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),

                  Card(
                    color: Colors.white30,
                    margin: EdgeInsets.only(left: 30, right: 120),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: DropdownButton(
                        items: songs_folders.map((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        hint: Text("Select folder",style: TextStyle(color: Colors.white),),
                        value: select_folder.isEmpty ? null : select_folder,
                        dropdownColor: Color(0xFFB98959),
                        icon: Icon(Icons.arrow_drop_down,color: Color(0xFFB98959)),
                        isExpanded: true,
                        onChanged: (newvalue) {
                          setState(() {
                            select_folder = newvalue.toString();
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  isloading
                      ? SpinKitCircle(
                          color: Colors.white,
                        )
                      : InkWell(
                          onTap: () {
                            if (image_file != null) {
                              _submit();
                            } else {
                              _showErrorDialog(context);
                            }

                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Colors.indigo,
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    stops: [0.001, 1])),
                            margin: EdgeInsets.only(left: 20, right: 30),
                            child: Center(
                                child: Text(
                              "POST",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        )

                  // ispressed?buildUploadStatus(task):Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
