
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:profit_mart/client_login.dart';
import 'package:profit_mart/home_main.dart';
import 'package:profit_mart/main_screen_desigin.dart';
import 'package:profit_mart/otpclient.dart';
import 'package:profit_mart/test.dart';

import 'gust_login.dart';


class screen extends StatefulWidget {
  const screen({Key? key}) : super(key: key);
  @override
  State<screen> createState() => _screenState();
}

class _screenState extends State<screen> {

  DateTime? currentBackPressTime;

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

  // bool _isLoading = false;
  //
  // void _startLoading() {
    // setState(() {
    //   _isLoading = true;
    // });

    // Simulate a time-consuming task
    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //
    //   // Navigate to the next page
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => gust(),
    //     ),
    //   );
    // });


    // Simulate a time-consuming task
    // Future.delayed(Duration(seconds: 2), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //
    //   // Navigate to the next page
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => homeMain(),
    //     ),
    //   );
    // });
  //}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              Container(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.64,
                    width: double.infinity,
                    child: Image.asset('assets/logo.png',
                      fit: BoxFit.contain,)
                ) ,
              ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.78,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 130,height: 45,
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

                            // onPressed: _isLoading ? null : _startLoading,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => gust()),
                              );
                            },
                            child: Text('Gust login', style: TextStyle(fontSize: 18, color: Colors.white),),
                          ),
                      ),

                      const SizedBox(width: 35),
                      SizedBox(width:130, height: 45,
                          child: ElevatedButton(style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation:0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Colors.lightGreenAccent,
                              ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),

                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => client()),
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => client()),
                              );
                            },

                            child:
                            const Text('Client Login',style: TextStyle(fontSize: 18),), )),

                    ],
                  ),

                ],
              ),
              // if (_isLoading)
              //   const Center(
              //     child: CircularProgressIndicator(
              //       backgroundColor: Colors.black26,
              //       valueColor: AlwaysStoppedAnimation(Colors.green),
              //
              //     ),
              //   ),
            ],

          ),

      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (currentBackPressTime == null) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => exit(0)),
      );

      //showAlertBox();


      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => mainScreenHome()),
      // );
    }
    return Future.value(false);
  }

}
