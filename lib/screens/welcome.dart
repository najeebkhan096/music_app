import 'package:flutter/material.dart';
import 'package:music_app/sign_up.dart';
class Welcome_Screen extends StatelessWidget {
  static const routename="Welcome_Screen";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfff5f2),
        elevation: 0,
        title: Text("Horspiel App",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
      ),
      body: ListView(
        children: [
          SizedBox(height: height*0.01,),
          Container(
            margin: EdgeInsets.only(left: width*0.1,right: width*0.1),
            decoration: BoxDecoration(
                color: Colors.blue,
              borderRadius: BorderRadius.circular(30)
            ),
            height: height*0.77,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Schnell einrichten",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
                SizedBox(height: height*0.035,),


                Icon(Icons.privacy_tip,color: Colors.white,size: 35,),
                SizedBox(height: height*0.02,),
                Text("Choose a PIN for the parent area",style: TextStyle(color: Colors.white,fontSize: 17),),
                SizedBox(height: height*0.035,),


                Icon(Icons.upload_file ,color: Colors.white,size: 35,),
                SizedBox(height: height*0.02,),
                Container(
                    width: width*0.6,
                    child: Text("Radio play CDs of SD Card or Add internal memory",style: TextStyle(color: Colors.white,fontSize: 17),)),
                SizedBox(height: height*0.035,),

                Icon(Icons.cleaning_services_sharp,color: Colors.white,size: 35,),
                SizedBox(height: height*0.02,),
                Container(
                    width: width*0.6,
                    child: Text("Choose a PIN for the parent area",style: TextStyle(color: Colors.white,fontSize: 17),textAlign: TextAlign.center,)),
                SizedBox(height: height*0.035,),


                Icon(Icons.color_lens,color: Colors.white,size: 35,),
                SizedBox(height: height*0.02,),
                Container(
                    width: width*0.6,
                    child: Text("Choose Player Color",style: TextStyle(color: Colors.white,fontSize: 17),textAlign: TextAlign.center,)),
                SizedBox(height: height*0.035,),

                Icon(Icons.switch_right_outlined,color: Colors.white,size: 35,),
                SizedBox(height: height*0.02,),
                Container(
                    width: width*0.6,
                    child: Text("Switch to Children's Mode",style: TextStyle(color: Colors.white,fontSize: 17),textAlign: TextAlign.center,)),
                SizedBox(height: height*0.035,),
              ],
            ),
          ),

          SizedBox(height: height*0.02,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: height*0.06,
                width: width*0.4,
                margin: EdgeInsets.only(left: width*0.05,right: width*0.05),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 2),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text("Back")),
              ),



              InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(Sign_up_Screen.routename);
                },
                child: Container(
                  height: height*0.06,
                  width: width*0.4,
                  margin: EdgeInsets.only(left: width*0.05,right: width*0.05),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,width: 2),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("Farther",style: TextStyle(color: Colors.white),)),
                ),
              ),
            ],
          ),
          SizedBox(height: height*0.02,),

        ],
      ),
    );
  }
}
