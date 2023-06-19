import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:profit_mart/home_main.dart';
import 'package:http/http.dart' as http;
import 'package:profit_mart/main_screen_desigin.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:profit_mart/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get.dart';
import 'otpclient.dart';


class otpclient extends StatefulWidget {
  String otpString;
  otpclient({Key? key,required this.otpString}) : super(key: key);

  @override
  State<otpclient> createState() => _otpclientState();

}


late SharedPreferences prefs;
List<Post>? posts = [];

var _showOtp = "";


class _otpclientState extends State<otpclient> {

  late BuildContext dialogcontext;


  showLoaderDialog(BuildContext context){
    dialogcontext = context;
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ),
          Container(margin: const EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(dialogcontext).pop();
  }


    void showAlertBoxPopUp2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wrong OTP!'),
          //content: Text('This is an alert box!'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => homeMain()),
                // );
                hideOpenDialog();
              },
            ),
          ],
        );
      },
    );
  }



  String clcode=GlobalClass.clcode_globalclass;
  TextEditingController cotp_textediting_controller =
  new TextEditingController();

  Future<void> getOtp_exist_in_databse_api() async {
    showLoaderDialog(context);

    var client = http.Client();
    String otp = cotp_textediting_controller.text;
    var uri = Uri.parse(base_url + 'otp?otp=' + otp + '&mobile='+GlobalClass.mobile_number_globalclass);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      // setState(() {
      //   _showOtp="8509";
      // });


     // print('json resp21 : '+json.toString());
      //show_otp_screen(json.toString());
      //showDataAlert(context,json.toString());
      Map<String, dynamic> map = jsonDecode(json);
      String isOtp_present = map['success'];
      if (isOtp_present == "true") {

        Future<void> save_to_shared_pref(String json) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('notification_list', json);
        }

        Future<List<Post>?> get_from_shared_pref() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var jsonStr = prefs.getString('notification_list')!;
          //print('get_from_shared_pref: $jsonStr');
          return postFromJson(jsonStr);
        }

        Future<int> get_from_shared_pref_logid(String lid) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var clcode = prefs.getString('clcode')!;
          //print('get_from_shared_pref: $jsonStr');
          return clcode as int;

        }

        print(clcode);



        if(otp==widget.otpString) {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mainScreenHome()),
          );
        }else {
          showAlertBoxPopUp2();
        }
      } else {
        // print('isclcode_present : $isOtp_present');
        showAlertBoxPopUp2();

      }
    }
  }


  @override
  void initState() {
    super.initState();
    //show_otp_screen('');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [


          Container(
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset('assets/economy.jpg',
                    fit: BoxFit.cover,
                    color: const Color(0814030)
                        .withOpacity(0.9), //Color.fromRGBO(0, 0, 0, 0.1),
                    colorBlendMode: BlendMode.modulate)),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(left: 150, top: 200),
          //   child: Text("otp is : " + widget.otpString, style: TextStyle(color: Colors.white),),
          // ),


          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: const Center(
              child: Text(
                'Please enter valid OTP ',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),




          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: TextField(
                  controller: cotp_textediting_controller,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  decoration: (InputDecoration(
                      labelText: ('OTP*'),
                      labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.lightGreenAccent, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.lightGreenAccent, width: 1),
                          borderRadius: BorderRadius.circular(10)))),
                ),
              ),
            ),
          ),

          // Container(
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height * 0.85,
          //     child: Center(
          //       child: Text(
          //         'Your OTP is : ' + _showOtp.toString(),
          //         style: TextStyle(
          //             fontSize: 15,
          //             color: Colors.white,
          //             fontWeight: FontWeight.w500),
          //       ),
          //     ),
          //   ),
          // ),


          // Column(
          //   children: [
          //     SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.4
          //     ),
          //     const Padding(
          //       padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
          //       child: Text('Resend OTP', style: TextStyle(color: Colors.white, fontSize: 18),),
          //     ),
          //
          //   ],
          // ),

          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.48,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 130,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            side: const BorderSide(
                              width: 1.0,
                              color: Colors.lightGreenAccent,
                            ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),

                        ),
                        onPressed: () {
                          getOtp_exist_in_databse_api();

                        },


                        child: const Text(
                          'Verify',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),

                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
