import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:profit_mart/data.dart';
import 'package:profit_mart/home_main.dart';
import 'package:profit_mart/past_perform.dart';
import 'package:profit_mart/report.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'about.dart';
import 'home.dart';
import 'main_screen_desigin.dart';

class product extends StatefulWidget {
  const product({Key? key}) : super(key: key);

  @override
  State<product> createState() => _productState();
}

class _productState extends State<product> {


  DateTime? currentBackPressTime;
  bool isOverlayVisible = false;

  void logout(BuildContext context) {
    // Clear cache
    DefaultCacheManager().emptyCache();
    callApi().setOtpVerifiedTag(false);

    // Navigate to the login screen or any other desired screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen()),
    );
  }

  void showAlertBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Are you sure you want to Exit?'),
          //content: Text('This is an alert box!'),
          actions: [

            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => homeMain()),
                // );
              },
            ),

            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => exit(0)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi().save_to_shared_pref_clcode(GlobalClass.clcode_globalclass);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset('assets/economy.jpg',
                      fit: BoxFit.cover, color: Color(0814030).withOpacity(0.9), //Color.fromRGBO(0, 0, 0, 0.1),
                      colorBlendMode: BlendMode.modulate)
              ) ,
            ),

            SizedBox(
                height: MediaQuery.of(context).size.height*0.24,
                width: double.infinity,
                child: const Center(child: Text('Products', style: TextStyle(color: Colors.white,
                    fontSize: 30,fontWeight: FontWeight.w400),))
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.17,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.45,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                          border: Border.all(
                              width: 1,
                              color: Colors.lightGreenAccent
                          ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15, 20, 8, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('1. Zero A/C Opening Fee.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1,),),

                            Text('2. Get FREE advanced Treading Terminal.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),

                            Text('3. Tread On the Go with our Mobile App.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),

                            Text('4. Cover Order & Competitive Leverage .' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),
                            Text('5. Complete transparency in trading via Digital contract notes & SMS trade confirmation.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),
                            Text('6. A dedicated Relationship Manager for personalized solutions.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),
                            Text('7. Click away individual back office portal.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),

                            Text('8. Customized portfolio tracker.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),




                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),

      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (currentBackPressTime == null) {


      //Navigator.of(context).pop();
      showAlertBox();


      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => mainScreenHome()),
      // );
    }
    return Future.value(false);
  }

}
