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



class Sign_up_Screen extends StatefulWidget {
  static const routename="Sign_up_Screen";
  @override
  _Sign_up_ScreenState createState() => _Sign_up_ScreenState();
}

class _Sign_up_ScreenState extends State<Sign_up_Screen> {
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
if(pincode.isNotEmpty){
  print("here");
  add_data(pincode).then((value) {
    Navigator.of(context).pushReplacementNamed(Parent_Screen.routename);
  });
}
else{
  setState(() {
    isloading=false;
  });
  _showErrorDialog("Please Enter PIN Code", context);
}

    } catch (error)
    {
      setState(() {
        isloading=false;
      });

    }
  }
  bool completed=false;

  Future add_data(String pin) async {
    print("add function");
    await Hive.openBox('admin_password').then((value) {
      final songsBox = Hive.box('admin_password');
      songsBox.put("password",pin);
    });

  }
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
    return Scaffold(
 backgroundColor: Color(0xFFfff5f2),
      body: SingleChildScrollView(
        child: Container(
          child: Column(

            children: <Widget>[


              SizedBox(
                height: height*0.2,
              ),
Center(child: Text("Parents' Area",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
              SizedBox(
                height: 10,
              ),
              Center(child: Text("Pin vergeben",style: TextStyle(fontSize: 15),)),
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


              SizedBox(height: MediaQuery.of(context).size.height*0.03,),

           Container(
               width: width*0.7,
               child: Text("Bitte wählen Sie sich ihren persönlichen 4- Stelligen PIN aus um in den Elternbereich zu gelangen.")),
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
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
                    'Set Pin',
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
        ),
      ),
    );

  }
}
