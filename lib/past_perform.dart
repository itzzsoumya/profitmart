import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:profit_mart/home_main.dart';
import 'package:profit_mart/product.dart';
import 'package:profit_mart/report.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:profit_mart/utils/base_url.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'about.dart';
import 'data.dart';
import 'get.dart';
import 'home.dart';
import 'main_screen_desigin.dart';

class pastperform extends StatefulWidget {
  const pastperform({Key? key}) : super(key: key);


  @override
  State<pastperform> createState() => _pastperformState();

}




class _pastperformState extends State<pastperform> {
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


  List<Post>? postss = [];

  TextEditingController dateinput = TextEditingController();

  Future<void> get_notificationShowbyDate_api() async {

    var client = http.Client();
    String date = dateinput.text;
    var uri = Uri.parse(
      '${base_url}notificationShowbyDate?clcode=${GlobalClass.clcode_globalclass}&date=$date',
    );
    print(uri);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      print('response123'+json);
      postss = postFromJson(json);
     // print('posts_list : ' + postss.toString());

      postss = postss?.reversed.toList();
     // print('posts_list : ' + postss!.last.closerateforsl);

      setState(() {

      });
    }
  }


  @override
  void initState() {
    dateinput.text = "Enter Date";
    super.initState();

    callApi().save_to_shared_pref_clcode(GlobalClass.clcode_globalclass);


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
                    fit: BoxFit.cover,
                    color: const Color(0814030).withOpacity(0.9),
                    //Color.fromRGBO(0, 0, 0, 0.1),
                    colorBlendMode: BlendMode.modulate)
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.5,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Colors.lightGreenAccent),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Center(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: dateinput,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.calendar_today,),
                            // iconColor: Colors.white70,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            labelStyle: TextStyle(color: Colors.white,
                                fontSize: 16),

                          ),

                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context, initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101)
                            );

                            if (pickedDate != null) {
                              print(pickedDate);
                              String formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(pickedDate);
                              print(formattedDate);

                              setState(() {
                                dateinput.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        )

                    ),
                  ),

                  SizedBox(width: 10,),

                  Container(
                    height: 40,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.24,
                    decoration: BoxDecoration(

                        border: Border.all(
                            width: 1, color: Colors.lightGreenAccent),
                    borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<
                                  Color?>(Colors.transparent),
                              elevation: MaterialStateProperty.all<double?>(0),
                            ),
                            onPressed: () {
                              get_notificationShowbyDate_api();

                            },
                            child: const Text('Search', style: TextStyle(
                                fontSize: 16),)),

                      ],
                    ),
                  ),

                ],
              ),
            ),


            if (postss!.length > 0)
              Column(
                children: [
                  const SizedBox(height: 80,
                  ),

                  // Expanded(
                  //   // flex: 1,
                  //   child: ListView.builder(
                  //     itemCount: postss?.length,
                  //     itemBuilder: (context, index) {
                  //       return SizedBox(
                  //         height: 230,
                  //         width: double.infinity,
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 8),
                  //           child: Card(
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(12.0),
                  //             ),
                  //             child: Column(
                  //               children: [
                  //
                  //                 Row(
                  //                   //flex: 1,
                  //                   children: [
                  //
                  //                     Padding(
                  //                       padding: const EdgeInsets.only(left: 6, top: 12),
                  //                       child: Container(
                  //                         height: 40,
                  //                         width: 42,
                  //                         decoration: BoxDecoration(
                  //                           borderRadius: const BorderRadius
                  //                               .all(
                  //                               Radius.circular(50)),
                  //                           color: postss![index]
                  //                               .buysell
                  //                               .toString() ==
                  //                               'Buy'
                  //                               ? Colors.lime
                  //                               : Colors.red,
                  //                           //color: Colors.green
                  //                         ),
                  //                         child: Center(
                  //                           child: Text(
                  //                             postss![index]
                  //                                 .buysell
                  //                                 .toString(),
                  //                             style: const TextStyle(
                  //                                 fontSize: 16,
                  //                                 color: Colors.white),
                  //                           ),
                  //                         ),
                  //
                  //                       ),
                  //                     ),
                  //
                  //                     Padding(
                  //                       padding:
                  //                       const EdgeInsets.only(left: 8, top: 5),
                  //                       child: Text(
                  //                         postss![index].msg.toString(),
                  //                         style: const TextStyle(
                  //                           fontSize: 13,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //
                  //                 Column(
                  //                   children: [
                  //                     Container(
                  //                       height: 130,
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.only(
                  //                             top: 13, left: 15),
                  //                         child: Row(
                  //                           mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                           children: [
                  //                             Expanded(
                  //                               //flex: 1,
                  //                               child: Padding(
                  //                                 padding: const EdgeInsets
                  //                                     .only(left: 5.0,),
                  //                                 child: Column(
                  //                                   children: [
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                         bottom: 4,),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'CALL',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Expanded(
                  //                                               child: Text(
                  //                                                 postss![index]
                  //                                                     .call
                  //                                                     .toString(),
                  //                                                 style: const TextStyle(
                  //                                                     fontSize: 14),
                  //                                               )),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'CMP',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Expanded(
                  //                                               child: Text(
                  //                                                 postss![index]
                  //                                                     .cmp
                  //                                                     .toString(),
                  //                                                 style: const TextStyle(
                  //                                                     fontSize: 14),
                  //                                               )),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: const EdgeInsets
                  //                                           .only(bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'STATUS',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Row(
                  //                                       children: [
                  //                                         Text(
                  //                                           postss![index]
                  //                                               .status
                  //                                               .toString(),
                  //                                           style: const TextStyle(
                  //                                               fontSize: 14),
                  //                                         ),
                  //                                       ],
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Expanded(
                  //                               // flex: 1,
                  //                               child: Padding(
                  //                                 padding: const EdgeInsets
                  //                                     .only(left: 20.0),
                  //                                 child: Column(
                  //                                   children: [
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'EXCHANGE',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             postss![index]
                  //                                                 .exchange
                  //                                                 .toString(),
                  //                                             style: TextStyle(
                  //                                                 fontSize: 14),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                               'TARGET',
                  //                                               style: TextStyle(
                  //                                                   fontSize: 12,
                  //                                                   color: Colors
                  //                                                       .grey
                  //                                                       .shade600)
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             postss![index]
                  //                                                 .target
                  //                                                 .toString(),
                  //                                             style: const TextStyle(
                  //                                                 fontSize: 14),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: const EdgeInsets
                  //                                           .only(bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'VALUE',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     const Row(
                  //                                       children: [
                  //                                         Text(' '),
                  //                                       ],
                  //                                     ),
                  //
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Expanded(
                  //                               //flex: 1,
                  //                               child: Padding(
                  //                                 padding: const EdgeInsets
                  //                                     .only(left: 20.0),
                  //                                 child: Column(
                  //                                   children: [
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'DAYS',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             postss![index]
                  //                                                 .days
                  //                                                 .toString(),
                  //                                             style: const TextStyle(
                  //                                                 fontSize: 14),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'SL',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             postss![index]
                  //                                                 .stoploss
                  //                                                 .toString(),
                  //                                             style: const TextStyle(
                  //                                                 fontSize: 14),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding:
                  //                                       const EdgeInsets.only(
                  //                                           bottom: 4),
                  //                                       child: Row(
                  //                                         children: [
                  //                                           Text(
                  //                                             'P&L',
                  //                                             style: TextStyle(
                  //                                                 fontSize: 12,
                  //                                                 color: Colors
                  //                                                     .grey
                  //                                                     .shade600),
                  //                                           ),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     const Row(
                  //                                       children: [
                  //                                         Text(' '),
                  //                                       ],
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //
                  //                   ],
                  //                 ),
                  //
                  //
                  //                 // SizedBox(height: 5,),
                  //                 Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Row(
                  //
                  //                     children: [
                  //                       Padding(
                  //                         padding:
                  //                         const EdgeInsets.only(
                  //                             top: 1, left: 10),
                  //                         child: Row(
                  //                           children: [
                  //                             Column(
                  //                               children: [
                  //                                 Text(
                  //                                   postss![index].sendtime
                  //                                       .toString(),
                  //                                   style: const TextStyle(
                  //                                       fontSize: 13,
                  //                                       color: Colors.grey),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //
                  //                       Padding(
                  //                         padding: const EdgeInsets.fromLTRB(
                  //                             110, 2, 4, 0),
                  //                         child: Column(
                  //                           children: [
                  //                             Text(
                  //                               postss![index].researcher
                  //                                   .toString(),
                  //                               style: const TextStyle(
                  //                                   fontSize: 13,
                  //                                   color: Colors.grey),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),

                  Expanded(

                    // flex: 1,
                    child: ListView.builder(
                      itemCount: postss?.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 255,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      //flex: 1,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6, top: 12),
                                          child: Container(
                                            height: 42,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(50)),
                                              color: postss![index]
                                                  .buysell
                                                  .toString() ==
                                                  'Buy'
                                                  ? Colors.lime
                                                  : Colors.red,
                                              //color: Colors.green
                                            ),
                                            child: Center(
                                              child: Text(
                                                postss![index].buysell.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 5),
                                          child: Text(
                                            postss![index].msg.toString(),
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 145,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13, left: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                //flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                          bottom: 4,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'CALL',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                  postss![index]
                                                                      .call
                                                                      .toString(),
                                                                  style:
                                                                  const TextStyle(
                                                                      fontSize: 14),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              postss![index]
                                                                  .market
                                                                  .toString() ==
                                                                  'At Market' ? 'ABOVE RATE': postss![index].market.toString().toUpperCase() ,

                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                  postss![index]
                                                                      .cmp
                                                                      .toString(),
                                                                  style:
                                                                  const TextStyle(
                                                                      fontSize: 15),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'STATUS',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            postss![index]
                                                                .getStatus(),
                                                            style:  TextStyle(color: getColorStatus(postss![index]
                                                                .getStatus()),
                                                                fontSize: 13),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                // flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 25.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'EXCHANGE',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              postss![index]
                                                                  .exchange
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text('TARGET',
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600)),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              postss![index].target.toString(),
                                                              style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'VALUE',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            postss![index].getvalue(),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                //flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 25.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'DAYS',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              postss![index]
                                                                  .days
                                                                  .toString(),
                                                              style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'SL',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              postss![index]
                                                                  .stoploss
                                                                  .toString(),
                                                              style:
                                                               const TextStyle(
                                                                  fontSize: 15,)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'P&L',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                          postss![index].getCloseretforsl(),
                                                            style:
                                                            TextStyle(
                                                            fontSize: 15,color: postss![index].getCloseretforsl() ==''?Colors.pink:(double.parse(postss![index].getCloseretforsl())  > 0 ?Colors.green : Colors.pink),
                                                            ),
                                                          )
                                                        ],
                                                      ),

                                                      Row(
                                                        children: [
                                                          Text(
                                                            postss![index].getPer().toString(),
                                                                style:
                                                                TextStyle(
                                                                fontSize: 12,color: postss![index].getCloseretforsl() ==''?Colors.pink:(double.parse(postss![index].getCloseretforsl())  > 0 ?Colors.green : Colors.pink),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 1, left: 10, bottom: 12),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    postss![index]
                                                        .sendtime
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              115, 2, 4, 12),
                                          child: Column(
                                            children: [
                                              Text(
                                                postss![index].researcher.toString().toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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

  Color getColorStatus(String text) {
    Color color;
    if(text=="STOP-LOSS HIT") {
      color = Colors.pink.shade500;
    }
    else {
      color = Colors.black;
    }
    return color;
  }

}
