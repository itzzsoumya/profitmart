import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:profit_mart/data.dart';
import 'package:profit_mart/main_screen_desigin.dart';
import 'package:profit_mart/past_perform.dart';
import 'package:profit_mart/product.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'about.dart';
import 'data_pdf.dart';
import 'get_pdf_api.dart';
import 'home.dart';
import 'home_main.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;

class report extends StatefulWidget {
  const report({Key? key}) : super(key: key);

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  List<Pdf>? pdf = [];
  DateTime? currentBackPressTime;
  bool isOverlayVisible = false;


  Future<void> getPdf() async{


    var client=http.Client();
    var res=await client.get(Uri.parse("https://ekyc.profitmart.in:46036/notificationadmin/pdf"));
    if(res.statusCode==200) {
      var jsonData=res.body;
      print("pdf jsonData : " + jsonData.toString());
      pdf = pdfFromJson(jsonData);
      setState(() {

      });
    }
  }

  // final List<String> pdfUrls = [
  //   'http:\/\/103.210.194.123:51527\/pdf\\weeklystockpick.pdf',
  //   'http:\/\/103.210.194.123:51527\/pdf\\CommodityWeeklyPerformance.pdf',
  //   'http:\/\/103.210.194.123:51527\/pdf\\EquityWeeklyPerformance.pdf',
  //   'http:\/\/103.210.194.123:51527\/pdf\\CommodityMonthlyPerformance.pdf',
  //   'http:\/\/103.210.194.123:51527\/pdf\\EquityMonthlyPerformance.pdf',
  //   'http:\/\/103.210.194.123:51527\/pdf\\WeeklyMarketAnalysis.pdf',
  //   'http:\/\/103.210.194.123:51527\/pdf\\CommodityPivotReport.pdf',
  //   'http:\/\/103.210.194.123:51527\/pdf\\EquityPivotReport.pdf","items'
  // ];
  //


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

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    callApi().save_to_shared_pref_clcode(GlobalClass.clcode_globalclass);
    getPdf();
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
        body:Stack(
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
                  padding: EdgeInsets.only(top: 60),
                  child: Text('Reports', style: TextStyle(fontSize: 30, color: Colors.white),),
                )
              ],
            ),


            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      width:  MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                          border: Border.all(
                              width: 1,
                              color: Colors.lightGreenAccent
                          ),
                        borderRadius: BorderRadius.circular(10)
                      ),


                      child: ListView.builder(
                        itemCount: pdf!.length,
                        itemBuilder: (context, index)
                        {

                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 12, right: 12, bottom: 5),
                              child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade600
                                ),
                                //color: Colors.grey.shade600,
                                child:  Center(
                                    child: Text(pdf![index].items,
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                      ),
                                    ),
                                ),
                              ),

                            ),
                            onTap: () {
                              launchUrlString(pdf![index].link);

                              //   var url = Uri.parse(pdf![index].link);
                              //   if (await canLaunchUrl(url)) {
                              //     await launchUrl(url);
                              //   } else {
                              //     throw 'Could not launch $url';
                              //   }

                            },
                          );

                        }


                    ),

                    ),
                  ],
                ),
              ],
            ),



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


