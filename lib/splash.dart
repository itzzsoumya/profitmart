import 'dart:async';

import 'package:flutter/material.dart';
import 'package:profit_mart/main.dart';
import 'package:profit_mart/main_screen_desigin.dart';
import 'package:profit_mart/utils/GlobalClass.dart';

import 'data.dart';
import 'home.dart';
import 'home_main.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}


class _splashState extends State<splash> {

  bool isLoading = false;

  void fetchData() {
    setState(() {
      isLoading = true;
    });

  }


  @override
  void initState() {
    super.initState();
    var otpVerified = callApi().getOtpVerifiedTag();
    fetchData();

    // Timer(const Duration(seconds: 2), () async {
    //   if (await otpVerified) {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder:
    //             (context) => const homeMain()
    //         )
    //     );
    //   }else{
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder:
    //             (context) => const screen()
    //         )
    //     );
    //   }
    // }

    Timer(const Duration(seconds: 2), () async {
      print("otpVerified : "+otpVerified.toString()+
          " gl_clcode : "+GlobalClass.clcode_globalclass);
      if (await otpVerified && GlobalClass.clcode_globalclass!=null
          && GlobalClass.clcode_globalclass!="" &&
          GlobalClass.clcode_globalclass!="null") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => const mainScreenHome()
            )
        );
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => const screen()
            )
        );
      }
    }
    );
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:

    //     Center(
    //     child: isLoading
    //     ? const CircularProgressIndicator(
    //     backgroundColor: Colors.grey,
    //     valueColor: AlwaysStoppedAnimation(Colors.green),
    // )
    //     :

    Stack(
          children: [
            Container(
              child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset('assets/economy.jpg',
                      fit: BoxFit.cover,
                      color: Color(0814030).withOpacity(0.9),
                      colorBlendMode: BlendMode.modulate)),
            ),
            Container(
              child: Center(
                child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    )),
              ),
            )
          ],
        ),
    );
  }
}
