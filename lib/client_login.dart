import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:profit_mart/home_main.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:profit_mart/utils/base_url.dart';

// import 'clientApiGet.dart';
import 'data.dart';
import 'otpclient.dart';

import 'package:http/http.dart' as http;

import 'utils/progress_indicator.dart';

class client extends StatefulWidget {
  const client({Key? key}) : super(key: key);

  @override
  State<client> createState() => _clientState();
}

class _clientState extends State<client> {
  late BuildContext dialogcontext;

  void showAlertBoxPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text('Invalid Client Code!'),
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




  TextEditingController clcode_textediting_controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  showLoaderDialog(BuildContext context){
    dialogcontext = context;
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
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

  Future<void> getclient_exist_in_databse_api() async {

    showLoaderDialog(context);
    var client = http.Client();
    String clcode = clcode_textediting_controller.text;
    GlobalClass.clcode_globalclass = clcode;
    var uri = Uri.parse(
        '${base_url}CheckforClCodeInDB?clcode=$clcode');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      print('json resp1 : $json');
      Map<String,dynamic> map = jsonDecode(json);
      String mobile = map["mobile"];
      GlobalClass.mobile_number_globalclass = mobile;
      int isclcode_present = map["isClcode"];
      if(isclcode_present==1){
        var uri = Uri.parse(
            '${base_url}ClientGuestLogin?clcode=$clcode&mobile=$mobile&fcm_token='+GlobalClass.firebase_token_globalclass+'&androidos=0&imei=0&version=0&model=0&cltype=0');
        var response = await client.get(uri);
        if (response.statusCode == 200) {
          hideOpenDialog();
          var json = response.body;
          print('json resp11 : $json');
          Map<String,dynamic> map = jsonDecode(json);
          String otp = map["otp"];
          Navigator.of(context).pop();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => otpclient(otpString: otp,)),
          );


        }


      }else{
        // print('isclcode_present : '+isclcode_present.toString());
        showAlertBoxPopUp();

      }

    }
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
                    fit: BoxFit.cover, color: Color(0814030).withOpacity(0.9), //Color.fromRGBO(0, 0, 0, 0.1),
                    colorBlendMode: BlendMode.modulate)
            ) ,
          ),


          Container(
            child:SizedBox(height: MediaQuery.of(context).size.height*0.3,
              child : const Center(
                child: Text('Welcome!!!',
                  style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: SizedBox(height: MediaQuery.of(context).size.height*0.7,
              child : Center(
                child:TextField(
                  controller: clcode_textediting_controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),

                  decoration: (
                      InputDecoration(
                          labelText: ('Client Code*'),
                          labelStyle: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w500),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.lightGreenAccent, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.lightGreenAccent, width: 1),
                              borderRadius: BorderRadius.circular(10)
                          )
                      )
                  ),

                ),

              ),
            ),
          ),



          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.48,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 150,height: 48,
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
                          getclient_exist_in_databse_api();
                        },
                        child:
                        const Text('Verify with OTP', style: TextStyle(fontSize: 14),
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
