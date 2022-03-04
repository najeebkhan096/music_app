import 'package:flutter/material.dart';
import 'package:music_app/screens/welcome.dart';
import 'package:music_app/screens/wrapper.dart';
import 'package:music_app/sign_up.dart';
class Splash_Screen extends StatelessWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
 backgroundColor: Color(0xFFfff5f2),
      body: Container(
        child: ListView(

          children: [
            SizedBox(height: height*0.1,),
            Center(child: Text("Willkommen bei",style: TextStyle(fontSize: 12),)),
            SizedBox(height: height*0.02,),
            Center(child: Text("Hörspiel App",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
            SizedBox(height: height*0.07,),
            Image.asset('assets/images/Group 42.png'),
            SizedBox(height: height*0.15,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed(Welcome_Screen.routename);

              },
              child: Container(
                height: height*0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff5466c2),
                ),
                margin: EdgeInsets.only(left: width*0.05,right: width*0.05,bottom: height*0.02),
                child: Center(child: Text("Start",style: TextStyle(color: Colors.white),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
