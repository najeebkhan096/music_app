import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';



class Change_Pin extends StatefulWidget {
  static const routename="Change_Pin";
  @override
  _Change_PinState createState() => _Change_PinState();
}

class _Change_PinState extends State<Change_Pin> {
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

  Future add_data(String pin) async {
    print("add function");
    await Hive.openBox('admin_password').then((value) {
      final songsBox = Hive.box('admin_password');
      songsBox.put("password",pin);
    });
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

add_data(pincode).then((value) =>Navigator.of(context).pop());
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
          Center(child: Text("Change Pin",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
          SizedBox(
            height: 10,
          ),
          Center(child: Text("Enter a new pin",style: TextStyle(fontSize: 15),)),
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


          SizedBox(height: MediaQuery.of(context).size.height*0.32,),

          isloading?
          SpinKitCircle(color: Colors.black,):
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Color(0xff5466c2),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10,
              ),
              minWidth: MediaQuery.of(context).size.width - 60,
              onPressed: () {
                _submit();
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),




          SizedBox(
            height: 10,
          ),

        ],
      ),
    );

  }
}
