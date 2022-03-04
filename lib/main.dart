// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/Sign_in_Screen.dart';
import 'package:music_app/admin/screens/accessories/add_song.dart';
import 'package:music_app/admin/screens/accessories/admin.dart';
import 'package:music_app/admin/screens/accessories/delete_song.dart';
import 'package:music_app/admin/screens/accessories/Parent_view.dart';
import 'package:music_app/library.dart';
import 'package:music_app/module/Admin_drawer.dart';
import 'package:music_app/module/Song_module.dart';
import 'package:music_app/module/app_drawer.dart';
import 'package:music_app/play_now.dart';
import 'package:music_app/providers/rmplayer.dart';
import 'package:music_app/screens/change_pin.dart';
import 'package:music_app/screens/splash.dart';
import 'package:music_app/screens/welcome.dart';
import 'package:music_app/screens/wrapper.dart';
import 'package:music_app/sign_up.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final applicationDocumentsDirectory=await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(applicationDocumentsDirectory.path);
  Hive.registerAdapter(SongModuleAdapter());
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>RMPlayer()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Wrapper(),
        routes: {
          'Welcome_Screen':(context)=>Welcome_Screen(),
          'Admin': (context) => Admin(),
          'Change_Pin':(context)=>Change_Pin(),
          'Admin_Setting':(context)=>Admin_Setting(),
          'Play_Now_Screen': (context) => Play_Now_Screen(),
          'Add_Song': (context) => Add_Song(),
          'Library_Screen': (context) => Library_Screen(),
          'Sign_in_Screen': (context) => Sign_in_Screen(),
          'Parent_Screen': (context) => Parent_Screen(),
          'Delete_Song': (context) => Delete_Song(),
          'Sign_up_Screen': (context) => Sign_up_Screen(),
          'Wrapper': (context) => Wrapper(),
          'AppDrawer': (context) => AppDrawer()
        }
        ),
    );
  }
}