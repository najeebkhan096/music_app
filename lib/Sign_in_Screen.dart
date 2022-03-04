import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:music_app/admin/screens/accessories/admin.dart';
import 'package:music_app/admin/screens/accessories/Parent_view.dart';
import 'package:music_app/library.dart';
import 'package:music_app/module/Song_module.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class Sign_in_Screen extends StatefulWidget {
  static const routename="Sign_in_Screen";
  @override
  _Sign_in_ScreenState createState() => _Sign_in_ScreenState();
}

class _Sign_in_ScreenState extends State<Sign_in_Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController textEditingController = TextEditingController();

  bool isloading=false;
bool is_register=false;
bool visibilty=true;
String pincode='';

  void _showErrorDialog(String msg,BuildContext context)
  {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occured'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            )
          ],
        )
    );
  }

  Future<void> _submit() async
  {
    if(!_formKey.currentState!.validate())
    {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isloading=true;
    });
    try{

      bool choice=true;
      await Hive.openBox('admin_password').then((value) {
        final songsBox = Hive.box('admin_password');
        print("rimsha"+songsBox.toString());
        String stored_password=songsBox.get('password');
        print(stored_password);
        if(stored_password==pincode){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(

            content: Text("Succesfully Logged in"),
          ));

        // Navigator.of(context).pushReplacementNamed(Parent_Screen.routename);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Parent_Screen()),
                  (route)=>false
          );
        }
        else{
          setState(() {
            isloading=false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Wrong Password"),
          ));

        }

      }
      );





    } catch (error)
    {
      setState(() {
        isloading=false;
      });

    }
  }
  bool completed=false;

  Future fetch()async{
    print("fetch function");
    await Hive.openBox('songs').then((value) {
      final songsBox=Hive.box('songs');
      // songsBox.put(
      //     "CD2", {
      //   'status':false,
      //   'songs':CD2
      // });
      Map<dynamic,dynamic> _map=songsBox.toMap();
      _map.forEach((key, value) {
        print("key is"+key);
if(value['status']){
  print("value is "+value['status'].toString());
}

      });

    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // add_data();
    // fetch();
    return Scaffold(
  backgroundColor: Color(0xFFfff5f2),
      body: ListView(
        children: <Widget>[

          SizedBox(
            height: height*0.2,
          ),
          Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock,size: 30,color: Colors.black,),
              Text("Parents' Area",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            ],
          )),
          SizedBox(
            height: 10,
          ),
          Center(child: Text("Enter pin",style: TextStyle(fontSize: 15),)),
          SizedBox(
            height: height*0.1,
          ),
          Container(
            margin: EdgeInsets.only(left: 15,right: 15),
            child: Form (
              key: _formKey,
              child: PinCodeTextField(
                appContext: context, length: 4,onChanged: (value){
                print(value);
              }, onCompleted: (value){
                setState(() {
                  completed=true;
                  pincode=value;

                });
              },
                boxShadows: [
                  BoxShadow(
                      color: Color(0xff5d6cc8)
                  ),
                  BoxShadow(
                      color: Color(0xff5d6cc8)
                  )
                ],

                onAutoFillDisposeAction: AutofillContextAction.cancel,
                controller: textEditingController,
                autoDisposeControllers: true,
                cursorColor: Colors.white,
                animationType: AnimationType.fade,
                textStyle: TextStyle(color: Colors.white),


                keyboardType: TextInputType.number,

                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(20),
                    fieldHeight: height*0.13,
                    fieldWidth: width*0.2,
                    activeColor: Colors.transparent,
                    selectedColor: Colors.black,
                    inactiveFillColor: Colors.black,
                    disabledColor: Colors.black,
                    activeFillColor: Colors.black,
                    inactiveColor: Colors.transparent

                ),
              ),
            ),
          ),


          SizedBox(height: MediaQuery.of(context).size.height*0.26,),

         isloading?
          SpinKitCircle(color: Colors.black,):
         InkWell(
           onTap: (){
             _submit();
           },
           child: Container(
             height: height*0.06,
             width: width*0.1,
             margin: EdgeInsets.only(left: width*0.05,right: width*0.05),
             decoration: BoxDecoration(
               color: Color(0xff5466c2),
               borderRadius: BorderRadius.circular(10),
             ),
             child: Center(
               child: Text(
                 'Log in',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 17,
                 ),
               ),
             ),
           ),
         ),




          SizedBox(
            height: 10,
          ),
          Container(
            height: height*0.06,
            width: width*0.1,
margin: EdgeInsets.only(left: width*0.05,right: width*0.05),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff5466c2),width: 2),
            color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text("Back")),
          ),
          SizedBox(
            height: 10,
          ),

        ],
      ),
    );

  }
}
