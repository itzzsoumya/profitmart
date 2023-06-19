import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:profit_mart/client_login.dart';
import 'package:profit_mart/home.dart';
import 'package:profit_mart/main_screen_desigin.dart';
import 'package:profit_mart/past_perform.dart';
import 'package:profit_mart/product.dart';
import 'package:profit_mart/report.dart';
import 'package:profit_mart/retrofit/apis.dart';
import 'package:profit_mart/retrofit/app_repository.dart';
import 'package:profit_mart/test.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:profit_mart/utils/progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about.dart';
import 'data.dart';
import 'get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class homeMain extends StatefulWidget {
  const homeMain({ Key? key}) : super(key: key);

  @override
  State<homeMain> createState() => homeMainState();
}

class homeMainState extends State<homeMain> {


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

  DateTime? currentBackPressTime;
  bool isOverlayVisible = false;
  bool _showProgress = false;


  bool callCheckboxChecked = false;
  bool exchangeCheckBoxChecked = false;
  bool isTopVisible = false;

  String dropdownValue = 'Intraday';
  String drpEx = 'NSE';
  late SharedPreferences prefs;
  late String selectVal;

  List<Post>? posts = [];
  var isLoaded = false;

  bool otpverified = true;
  bool _showHideSettingView = false;
  onFilterClicked(bool b){
    debugPrint(b?"onFilteredClicked: true":"onFilteredClicked: false");
    setState(() {
      _showHideSettingView = b;
    });
  }

  void fetchData() {
    setState(() {
      _showProgress = true;
    });

  }

  @override
  void initState() {
    super.initState();
    callApi().setOtpVerifiedTag(true);
    callApi().save_to_shared_pref_clcode(GlobalClass.clcode_globalclass);

    getData();
    fetchData();

    // Timer(Duration(seconds: 2), () {
    //   setState(() {
    //     _showProgress = false;
    //   });
    // });

    // FirebaseMessaging.instance.getToken().then((newToken) {
    //   print("FCM Token ");
    //   print(newToken);
    //   print('......');
    //
    //   //tokenService.updateTokenOnServer(newToken);
    // }
    // );

    //app open from terminated state n get notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
     // print('FirebaseMessaging.instance.getInitialMessage');
      if (message != null) {
      //  print('New Notification');
      }
    });

    //method call when app in foreground its mean app is open
    FirebaseMessaging.onMessage.listen((message) {
     // print("FirebaseMessage.onMessage.listen");
      if (message.notification != null) {
       // print(message.notification!.title);
       // print(message.notification!.body);
       // print("message.data11 ${message.data}");
      }
    });

    //call when app in bg not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
     // print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
       // print(message.notification!.title);
       // print(message.notification!.body);
       // print("message.data22  ${message.data['_id']}");
      }
    });

   }
  getData() async {
    final List<Post>? _posts = await callApi().getPosts(0);
    if (_posts != null) {
      //save_to_shared_pref(posts!);
      posts = _posts.reversed.toList();
      setState(() {
        //print(posts?.length);
      });
    }
  }


  getDataFromSharePref(bool filter,bool hasRemovedFilter) async {
    posts?.clear();
    List<Post>? p = await callApi().get_from_shared_pref();
    if (hasRemovedFilter && p != null && p.length > 0) {
      int logid = await callApi().get_from_shared_pref_logid();
      List<Post>? p_temp = await callApi().getPosts(logid);
      p.addAll(p_temp as Iterable<Post>);
    }

    if (hasRemovedFilter) {
      setState(() {
        //posts = p;
        posts?.clear();
        posts = p?.reversed.toList();
      });
    } else {
      List<Post>? temp = [];
      if (callCheckboxChecked && exchangeCheckBoxChecked) {
        p?.forEach((element) {
          if (element.call == dropdownValue && element.exchange == drpEx) {
            temp.add(element);
          }
        });
      } else if (callCheckboxChecked) {
        p?.forEach((element) {
          // print("call_xyz : "+element.call);
          if (element.call == dropdownValue) {
            // print("true xyz");
            temp.add(element);
          }
        });
        //print("templist : "+temp.toString());
      } else if (exchangeCheckBoxChecked) {
        p?.forEach((element) {
          if (element.exchange == drpEx) {
            temp.add(element);
          }
        });
      }else{
        p?.forEach((element) {
          temp.add(element);
        });
      }


      //List<Post>? _posts = await callApi().getPosts(0);
      if (temp != null) {
        //save_to_shared_pref(posts!);
        posts = temp.reversed.toList();
        // setState(() {
        //   //print(posts?.length);
        // });
      }

      setState(() {
        //posts?.addAll(temp);
        //posts?.addAll(temp2);
      });
    }
  }

  Future<void> save_to_shared_pref(List<Post> post) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('notification_list', post.toString());
    prefs.setString('clcode', GlobalClass.clcode_globalclass);
  }

  Future<void> get_from_shared_pref() async {
    posts = prefs.getString('notification_list')! as List<Post>;
    // print("check111 :${posts![0].msg}");
  }


  List<Post> postFromJson(String str) {
    //print("RRR nEW : ${List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)))}");
    return List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));
  }

  void showAlertBoxExit() {
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => homeMain()),
                // );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,

          body: Column(
            children: [
              Visibility(
                visible: _showHideSettingView,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: CupertinoColors.black,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.green.withOpacity(.32);
                                  }
                                  return Colors.green;
                                }),
                                value: callCheckboxChecked,
                                onChanged: (value) {
                                  setState(() {
                                    callCheckboxChecked = value!;
                                  });
                                },
                              ),
                              const Text(
                                'CALL :',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.24),
                              Container(
                                  height: 30,
                                  width: 155,
                                  padding: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.green)),
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    //icon: const Icon(Icons.arrow_downward),
                                    iconSize: 20,
                                    underline: const SizedBox(),
                                    iconEnabledColor: Colors.green,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 18),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Intraday',
                                      'BTST',
                                      'Option strategy',
                                      'Delivery',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.green.withOpacity(.32);
                                  }
                                  return Colors.green;
                                }),
                                value: exchangeCheckBoxChecked,
                                onChanged: (value2) {
                                  setState(() {
                                    exchangeCheckBoxChecked = value2!;
                                  });
                                },
                              ),
                              const Text(
                                'EXCHANGE :',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12),
                              Container(
                                  height: 30,
                                  width: 155,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.green)),
                                  child: DropdownButton<String>(
                                    value: drpEx,
                                    //icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    iconEnabledColor: Colors.green,
                                    underline: SizedBox(),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 18),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        drpEx = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'NSE',
                                      'FNO',
                                      'CDS',
                                      'MCX',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value2) {
                                      return DropdownMenuItem<String>(
                                        value: value2,
                                        child: Text(value2),
                                      );
                                    }).toList(),
                                  )),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Row(
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2),
                              Container(
                                height: 30,
                                width: 90,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      getDataFromSharePref(true,false);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      side: const BorderSide(
                                        width: 1.0,
                                        color: Colors.green,
                                      )),
                                  child: const Text(
                                    'FILTER',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.059),
                              Container(
                                height: 31,
                                width: 160,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                // decoration: BoxDecoration(
                                //     border: Border.all(width: 2, color: Colors.green)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    getDataFromSharePref(false,true);
                                    //homeMain();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      side: const BorderSide(
                                        width: 1.0,
                                        color: Colors.green,
                                      )),
                                  child: const Text(
                                    'REMOVE FILTER',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              // Expanded(
              //   // flex: 1,
              //   child: ListView.builder(
              //     itemCount: posts?.length,
              //     itemBuilder: (context, index) {
              //       return SizedBox(
              //         height: 255,
              //         width: double.infinity,
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 5),
              //           child: Card(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(14.0),
              //             ),
              //             child: Column(
              //               children: [
              //                 Expanded(
              //                   child: Row(
              //                     //flex: 1,
              //                     children: [
              //                       Padding(
              //                         padding: const EdgeInsets.only(
              //                             left: 6, top: 12),
              //                         child: Container(
              //                           height: 42,
              //                           width: 40,
              //                           decoration: BoxDecoration(
              //                             borderRadius: const BorderRadius.all(
              //                                 Radius.circular(50)),
              //                             color: posts![index]
              //                                         .buysell
              //                                         .toString() ==
              //                                     'Buy'
              //                                 ? Colors.lime
              //                                 : Colors.red,
              //                             //color: Colors.green
              //                           ),
              //                           child: Center(
              //                             child: Text(
              //                               posts![index].buysell.toString(),
              //                               style: const TextStyle(
              //                                   fontSize: 15,
              //                                   color: Colors.white),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                       Padding(
              //                         padding: const EdgeInsets.only(
              //                             left: 8, top: 5),
              //                         child: Text(
              //                           posts![index].msg.toString(),
              //                           style: const TextStyle(
              //                             fontSize: 13,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //
              //                 Column(
              //                   children: [
              //                     SizedBox(
              //                       height: 145,
              //                       child: Padding(
              //                         padding: const EdgeInsets.only(
              //                             top: 13, left: 6),
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.spaceBetween,
              //                           children: [
              //                             Expanded(
              //                               //flex: 1,
              //                               child: Padding(
              //                                 padding: const EdgeInsets.only(
              //                                   left: 5.0,
              //                                 ),
              //                                 child: Column(
              //                                   children: [
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                         bottom: 4,
              //                                       ),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             'CALL',
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Expanded(
              //                                               child: Text(
              //                                             posts![index]
              //                                                 .call
              //                                                 .toString(),
              //                                             style:
              //                                                 const TextStyle(
              //                                                     fontSize: 14),
              //                                           )),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             posts![index]
              //                                                 .market
              //                                                 .toString() ==
              //                                                 'At Market' ? 'ABOVE RATE': posts![index].market.toString().toUpperCase() ,
              //
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Expanded(
              //                                               child: Text(
              //                                             posts![index]
              //                                                 .cmp
              //                                                 .toString(),
              //                                             style:
              //                                                 const TextStyle(
              //                                                     fontSize: 15),
              //                                           )),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             'STATUS',
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Row(
              //                                       children: [
              //
              //
              //
              //                                         Text(
              //                                           posts![index]
              //                                                .getStatus(),
              //                                           style: const TextStyle(
              //                                               fontSize: 13),
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
              //                                 padding: const EdgeInsets.only(
              //                                     left: 25.0),
              //                                 child: Column(
              //                                   children: [
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             'EXCHANGE',
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             posts![index]
              //                                                 .exchange
              //                                                 .toString(),
              //                                             style: const TextStyle(
              //                                                 fontSize: 14),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text('TARGET',
              //                                               style: TextStyle(
              //                                                   fontSize: 12,
              //                                                   color: Colors
              //                                                       .grey
              //                                                       .shade600)),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             posts![index].target.toString(),
              //                                             style:
              //                                                 const TextStyle(
              //                                                     fontSize: 15),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             'VALUE',
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                      Row(
              //                                       children: [
              //                                         Text(
              //                                           posts![index].closerateforsl.toString(),
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                             ),
              //                             Expanded(
              //                               //flex: 1,
              //                               child: Padding(
              //                                 padding: const EdgeInsets.only(
              //                                     left: 25.0),
              //                                 child: Column(
              //                                   children: [
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             'DAYS',
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             posts![index]
              //                                                 .days
              //                                                 .toString(),
              //                                             style:
              //                                                 const TextStyle(
              //                                                     fontSize: 15),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             'SL',
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             posts![index]
              //                                                 .stoploss
              //                                                 .toString(),
              //                                             style:
              //                                                 const TextStyle(
              //                                                     fontSize: 15),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               bottom: 4),
              //                                       child: Row(
              //                                         children: [
              //                                           Text(
              //                                             'P&L',
              //                                             style: TextStyle(
              //                                                 fontSize: 12,
              //                                                 color: Colors.grey
              //                                                     .shade600),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                     Row(
              //                                       children: [
              //                                         Text(
              //                                           posts![index].getCloseretforsl(),
              //                                         ),
              //                                       ],
              //                                     ),
              //
              //                                     Row(
              //                                       children: [
              //                                         Text(
              //                                           posts![index].getPer().toString(),
              //                                         ),
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
              //                   ],
              //                 ),
              //
              //                 // SizedBox(height: 5,),
              //                 Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Row(
              //                     children: [
              //                       Padding(
              //                         padding: const EdgeInsets.only(
              //                             top: 1, left: 10, bottom: 12),
              //                         child: Row(
              //                           children: [
              //                             Column(
              //                               children: [
              //                                 Text(
              //                                   posts![index]
              //                                       .sendtime
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
              //                       Padding(
              //                         padding: const EdgeInsets.fromLTRB(
              //                             115, 2, 4, 12),
              //                         child: Column(
              //                           children: [
              //                             Text(
              //                               posts![index].researcher.toString().toUpperCase(),
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
                  itemCount: posts?.length,
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
                                          color: posts![index]
                                              .buysell
                                              .toString() ==
                                              'Buy'
                                              ? Colors.lime
                                              : Colors.red,
                                          //color: Colors.green
                                        ),
                                        child: Center(
                                          child: Text(
                                            posts![index].buysell.toString(),
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
                                        posts![index].msg.toString(),
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
                                                              posts![index]
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
                                                          posts![index]
                                                              .market
                                                              .toString() ==
                                                              'At Market' ? 'ABOVE RATE': posts![index].market.toString().toUpperCase() ,

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
                                                              posts![index]
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
                                                        posts![index]
                                                            .getStatus(),
                                                        style:  TextStyle(color: getColorStatus(posts![index]
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
                                                          posts![index]
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
                                                          posts![index].target.toString(),
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
                                                        posts![index].getvalue(),
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
                                                          posts![index]
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
                                                            posts![index]
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
                                                        posts![index].getCloseretforsl(),
                                                        style:
                                                        TextStyle(
                                                          fontSize: 15,color: posts![index].getCloseretforsl() ==''?Colors.pink:(double.parse(posts![index].getCloseretforsl())  > 0 ?Colors.green : Colors.pink),
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                  Row(
                                                    children: [
                                                      Text(
                                                        posts![index].getPer().toString(),
                                                        style:
                                                        TextStyle(
                                                          fontSize: 12,color: posts![index].getCloseretforsl() ==''?Colors.pink:(double.parse(posts![index].getCloseretforsl())  > 0 ?Colors.green : Colors.pink),
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
                                                posts![index]
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
                                            posts![index].researcher.toString().toUpperCase(),
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
          ),
        ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    DateTime now = DateTime.now();
    if (isOverlayVisible) {
      Navigator.pop(context); // Dismiss the pop-up dialog
      return Future.value(false);
    } else if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      // Show a snackbar or toast message indicating to double-tap to exit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );

      currentBackPressTime = now;
      return Future.value(false);
    } else {
      // Show the pop-up dialog
      setState(() {
        isOverlayVisible = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                  setState(() {
                    isOverlayVisible = false;
                  });
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog and exit
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        },
      );

      return Future.value(false);
    }
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
