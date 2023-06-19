import 'dart:async';

import 'package:flutter/material.dart';

import 'home.dart';

class gust extends StatefulWidget {
  const gust({Key? key}) : super(key: key);

  @override
  State<gust> createState() => _gustState();
}

TextEditingController nameController=new TextEditingController();

class _gustState extends State<gust> {


  bool _showProgress = true;

  @override
  void initState() {
    super.initState();

    // // Start a timer to hide the progress indicator after a specific duration
    // Timer(Duration(seconds: 1), () {
    //   setState(() {
    //     _showProgress = false;
    //   });
    // });


  }


  void showAlertBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mobile Number Verified Successfully'),
          //content: Text('This is an alert box!'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen()),
                );
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset('assets/economy.jpg',
                  fit: BoxFit.cover, color: Color(0814030).withOpacity(0.9), //Color.fromRGBO(0, 0, 0, 0.1),
                  colorBlendMode: BlendMode.modulate)
          ),

          SizedBox(height: MediaQuery.of(context).size.height*0.3,
            child : const Center(
              child: Text('Welcome Guest !!!',
                style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w500),),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: SizedBox(height: MediaQuery.of(context).size.height*0.7,
              child : Center(
                child:TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.number,
                  controller: nameController,
                  decoration: (
                      InputDecoration(
                          labelText: ('Mobile Number*'),
                          labelStyle: const TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),
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

                          print(nameController.text.toString()
                          );

                          showAlertBox();

                        },
                        child:
                        const Text('Verify with OTP', style: TextStyle(fontSize: 14),
                        ),
                      )),

                ],
              ),
            ],
          ),

          // if (_showProgress)
          //   const Center(
          //     child: CircularProgressIndicator(
          //       backgroundColor: Colors.black26,
          //       valueColor: AlwaysStoppedAnimation(Colors.green),
          //
          //     ),
          //   ),

        ],


      ),
    );
  }
}
