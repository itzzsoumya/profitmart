import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:profit_mart/past_perform.dart';
import 'package:profit_mart/product.dart';
import 'package:profit_mart/report.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';
import 'home.dart';
import 'home_main.dart';
import 'main_screen_desigin.dart';

class about extends StatefulWidget {
  const about({Key? key}) : super(key: key);

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {

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


  void showAlertBoxExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you want to exit ?'),
          //content: Text('This is an alert box!'),
          actions: [
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

            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),

          ],
        );
      },
    );
  }

  void showAlertBoxLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you want to Logout ?'),
          //content: Text('This is an alert box!'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                logout(context);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen()),
                );
              },
            ),

            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset('assets/economy.jpg',
                    fit: BoxFit.cover, color: const Color(0814030).withOpacity(0.9), //Color.fromRGBO(0, 0, 0, 0.1),
                    colorBlendMode: BlendMode.modulate)
            ),



            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('About Us', style: TextStyle(color: Colors.white,
                      fontSize: 24,fontWeight: FontWeight.w400),),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [


                SizedBox(height: MediaQuery.of(context).size.height*0.07,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    elevation: 20,
                    side: const BorderSide(
                      width: 2.0,
                      color: Colors.lightGreenAccent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),),
                    minimumSize: Size(50, 40),
                  ),
                  onPressed: () {
                    GestureDetector(
                      onTap: () => _launchEmail(),
                      child: const Text('support@profitmart.in ', style: TextStyle(color: Colors.white,
                          fontSize: 14,fontWeight: FontWeight.w400),),
                    );

                  },

                  child: const Text('Get in touch', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/call_green.png', width: 40, height: 30,),

                    GestureDetector(
                      onTap: () => _launchPhoneCall(),
                      child: const Text('020 49119119 ', style: TextStyle(color: Colors.white,
                          fontSize: 14,fontWeight: FontWeight.w400),),
                    ),


                    // Text('020 49119119 ', style: TextStyle(color: Colors.white,
                    //     fontSize: 14,fontWeight: FontWeight.w400),),

                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.height*0.01,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/mail.png', width: 40, height: 30,),

                    GestureDetector(
                      onTap: () => _launchEmail(),
                      child: const Text('support@profitmart.in ', style: TextStyle(color: Colors.white,
                          fontSize: 14,fontWeight: FontWeight.w400),),
                    ),

                    // Text('support@profitmart.in ', style: TextStyle(color: Colors.white,
                    //     fontSize: 14,fontWeight: FontWeight.w400),),

                  ],
                ),

                SizedBox(height: MediaQuery.of(context).size.height*0.01,),


                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.48,
                      width: MediaQuery.of(context).size.width*0.93,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                          border: Border.all(
                              width: 1,
                              color: Colors.lightGreenAccent,
                          ),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 2),
                            child: Text('PROFITMART is a premier Broking house offering diversified investment options like '
                                'Equities,Derivatives,Currency,Commodities,IPO,Mutual Funds and Real Estate.'
                                'At PROFITMART, we focus on delivering efficient trading software, supported with effective investing tools, which '
                                'are helpful to maximize your profits. we have been hard at work creating an investment experience to achieve your financial goals'
                                'It is our passion to offer you the best Product, Technology & Service. We ensure the trading experience at '
                                'PROFITMART to be one of its kind,with the help of our expertise.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 0 ),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 2),
                            child: Text('You deserve a better way to invest. We aim to deliver it.' ,
                              style: TextStyle(color: Colors.white,fontSize: 15, letterSpacing: 1),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Powered by   ', style: TextStyle(color: Colors.white,
                        fontSize: 14,fontWeight: FontWeight.w400),),
                    Image.asset('assets/xtremesoftlogo.png', width: 120, height: 90,)
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


void _launchPhoneCall() async {
  final Uri params = Uri(
    scheme: 'tel',
    path: '020 49119119',
  );

  String url = params.toString();

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void _launchEmail() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'support@profitmart.in',
    // query: 'subject=Hello%20World&body=This%20is%20a%20test',
  );

  String url = params.toString();

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }




}



