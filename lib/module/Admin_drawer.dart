import 'package:flutter/material.dart';
import 'package:music_app/Sign_in_Screen.dart';
import 'package:music_app/library.dart';
import 'package:music_app/play_now.dart';
import 'package:music_app/screens/change_pin.dart';
import 'package:music_app/sign_up.dart';

class Admin_Setting extends StatelessWidget {
  static const routename = "Admin_Setting";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFfff5f2),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                            Text("Back")
                          ],
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Setting ",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Divider(),
            ListTile(
              leading: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              title: Text("Change Pin", style: TextStyle(color: Colors.black)),
              onTap: () async {
                Navigator.of(context).pushNamed(Change_Pin.routename);
              },
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
                size: 18,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text("Child Mode", style: TextStyle(color: Colors.black)),
              onTap: () async {
                // Navigator.of(context)
                //     .pushReplacementNamed(Library_Screen.routename);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Library_Screen()),
                        (route)=>false
                );
              },
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
                size: 18,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.cleaning_services_sharp,
                color: Colors.black,
              ),
              title:
              Text("Change Color", style: TextStyle(color: Colors.black)),
              onTap: () async {},
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
                size: 18,
              ),
            ),
            SizedBox(height: 20,),
            ListTile(
              leading: Icon(
                Icons.person_rounded,
                color: Colors.black,
              ),
              title: Text("About to", style: TextStyle(color: Colors.black)),
              onTap: () async {

              },
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
                size: 18,
              ),
            ),

            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip,
                color: Colors.black,
              ),
              title: Text("Privacy", style: TextStyle(color: Colors.black)),
              onTap: () async {

              },
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
                size: 18,
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.feedback,
                color: Colors.black,
              ),
              title: Text("Give feedback", style: TextStyle(color: Colors.black)),
              onTap: () async {

              },
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
                size: 18,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
