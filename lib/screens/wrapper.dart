
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/Sign_in_Screen.dart';
import 'package:music_app/admin/screens/accessories/Parent_view.dart';
import 'package:music_app/library.dart';
import 'package:music_app/screens/splash.dart';
import 'package:music_app/sign_up.dart';
import 'package:provider/provider.dart';




class Wrapper extends StatelessWidget {
  static const routename = 'Wrapper';
  @override
  Widget build(BuildContext context) {

    Future<bool> Check_position() async {

      bool admin = false;
        await Hive.openBox('admin_password').then((value) {
          final songsBox = Hive.box('admin_password');
          print("rimsha"+songsBox.toString());
          if(songsBox.isEmpty){
            admin=false;
          }
          else{
            admin=true;
          }
        });

      return admin;

    }



    return   FutureBuilder(
        future: Check_position(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? SpinKitCircle(
            color: Colors.white,
          )
              :snapshot.data==true?
          Library_Screen()
              :Splash_Screen();
        });
  }
}