import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:profit_mart/past_perform.dart';
import 'package:profit_mart/product.dart';
import 'package:profit_mart/report.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'about.dart';
import 'data.dart';
import 'get.dart';
import 'home.dart';
import 'home_main.dart';



class mainScreenHome extends StatefulWidget {
  const mainScreenHome({Key? key}) : super(key: key);

  @override
  State<mainScreenHome> createState() => _mainScreenHomeState();


}


class _mainScreenHomeState extends State<mainScreenHome> {

  int _selectedIndex = 0;
  bool isFilterVisible=false;

  var homeKey = GlobalKey<homeMainState>();

  void _onItemTapped(int index) {
    Navigator.of(context).pop();
    setState(() {
      _selectedIndex = index;
      if(index==0){
        isTopIconVisible=true;

      }else{
        isTopIconVisible=false;
      }
    });
  }

  void logout(BuildContext context) {

    DefaultCacheManager().emptyCache();
    callApi().setOtpVerifiedTag(false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen()),
    );



  }

  DateTime? currentBackPressTime;
  bool isOverlayVisible = false;
  bool _showProgress = true;


  bool callCheckboxChecked = false;
  bool exchangeCheckBoxChecked = false;
  bool isTopVisible = false;
  bool isTopIconVisible = true;

  String dropdownValue = 'Intraday';
  String drpEx = 'NSE';
  late SharedPreferences prefs;
  late String selectVal;

  List<Post>? posts = [];
  var isLoaded = false;

  bool otpverified = true;

  @override
  void initState() {
    super.initState();
    callApi().setOtpVerifiedTag(true);
    callApi().save_to_shared_pref_clcode(GlobalClass.clcode_globalclass);

    getData();

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

  getDataFromSharePref(bool hasRemovedFilter) async {
    posts?.clear();
    setState(() {
      var isLoaded = true;
    });

    List<Post>? p = await callApi().get_from_shared_pref();
    if (hasRemovedFilter && p != null && p.length > 0) {
      int logid = await callApi().get_from_shared_pref_logid();
      List<Post>? p_temp = await callApi().getPosts(logid);
      p.addAll(p_temp as Iterable<Post>);
    }

    if (hasRemovedFilter) {
      setState(() {
        posts = p;
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
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Are you sure you want to exit?'),
          //content: Text('This is an alert box!'),
          actions: [

            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();

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
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to Logout?'),
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


                logout(context);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => screen()),
                // );
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  // void showAlertBoxButtonSheet() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Center(child: const Text('Disclaimer & Disclosure',)),
  //         //content: Text('This is an alert box!'),
  //         actions: [
  //           TextButton(
  //             child: const Text('Ok'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  void showAlertBoxButtonSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup();
      },
    );
  }



  _launchURLBrowser() async {
    var url = Uri.parse("https://ekyc.profitmart.in:46036/NseIPO1/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url,mode: LaunchMode.externalApplication );
    } else {
      throw 'Could not launch $url';
    }
  }




  _launchURLBrowser2() async {
    var url = Uri.parse("https://ekyc.profitmart.in:8000/index.aspx");
    if (await canLaunchUrl(url)) {
      await launchUrl(url,mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    //return WillPopScope(
      //onWillPop: () => _onWillPop(context),
      //child:
      return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: CupertinoColors.black,
          centerTitle: true,
          title: Image.asset('assets/logo.png', height: 50),
          actions: [
            Visibility(
              visible: isTopIconVisible,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isTopVisible = !isTopVisible;
                    if(homeKey.currentState != null){
                      homeKey.currentState!.onFilterClicked(isTopVisible);
                    }
                  });
                },
                icon: Icon(Icons.filter_alt_outlined),
              ),
            ),
          ],
        ),

        bottomSheet: Container(
          height: 20,
          width: double.infinity,
          color: CupertinoColors.label,
          child: GestureDetector(
            onTap: () {
              showAlertBoxButtonSheet(context);
            },
            child: const Center(
              child: Text(
                'Disclaimer & Disclosure',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),

          // InkWell(
          //   child: Center(
          //     child: Text("Disclaimer & Disclosure",
          //       style: TextStyle(color: Colors.white, fontSize: 16),),
          //   ),
          //   onTap: () {
          //     showAlertBoxButtonSheet();
          //   },
          // ),



        ),

        drawer: Drawer(
          child: ListView(
            children: <Widget> [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                color: Colors.green.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Image.asset(
                        'assets/logo.png',
                        width: double.infinity,
                      ),
                      Text(
                        "Client Code: " +GlobalClass.clcode_globalclass,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      //Text(GlobalClass.clcode_globalclass)
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home,color: Colors.grey),
                title: Text("Home", style: TextStyle(color: Colors.black87),),
                //onTap: () {
                  //Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => homeMain()),
                  // );
                //},

                  selected: _selectedIndex == 0,
                  onTap: () {

                    _onItemTapped(0);
                  } ,

              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.black87,
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.grey,),
                title: const Text("Past Performance",style: TextStyle(color: Colors.black87),),
                //onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const homeMain()),
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => pastperform()),
                  // );
                //},

                  selected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),

              ),
              ListTile(
                leading: Icon(Icons.folder, color: Colors.grey,),
                title: Text("Product", style: TextStyle(color: Colors.black87),),
                //onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => homeMain()),
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => product()),
                  // );
                //},

                  selected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),

              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.score, color: Colors.grey,),
                title: Text("IPO Apply", style: TextStyle(color: Colors.black87),),
                onTap: () {
                  Navigator.of(context).pop();
                  //_launchURLBrowser();

                  launchUrl(Uri.parse(
                      "https://ekyc.profitmart.in:46036/NseIPO1/"));

                 //launchUrlString("https://ekyc.profitmart.in:46036/NseIPO1/");



                   },
              ),
              ListTile(
                leading: Icon(Icons.perm_contact_cal, color: Colors.grey,),
                title: Text("EKYC", style: TextStyle(color: Colors.black87),),
                onTap: () {
                  Navigator.of(context).pop();
                  launchUrl(Uri.parse(
                      "https://ekyc.profitmart.in:8000/index.aspx"));

                 // _launchURLBrowser2();
                },
              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.event_note_sharp, color: Colors.grey,),
                title: Text("Reports", style: TextStyle(color: Colors.black87),),
                //onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => homeMain()),
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => report()),
                  // );
                //},


                  selected: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),

              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Colors.grey,),
                title: Text("About Us", style: TextStyle(color: Colors.black87),),
                //onTap: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => homeMain()),
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => about(),
                  //   ),
                  // );
                //},

                  selected: _selectedIndex == 4,
                  onTap: () => _onItemTapped(4),


              ),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app_outlined, color: Colors.grey,),
                title: Text("Exit", style: TextStyle(color: Colors.black87),),
                onTap: () {
                  showAlertBoxExit();
                  // exit(0);
                },
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.086,
              // ),
              SizedBox(
                child: Container(
                    height: 60,
                    width: double.infinity,
                    // color: Colors.green.shade800,
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.grey,
                              ),
                              title: const Text(
                                "LogOut",
                                style: TextStyle(
                                  color: Colors.black87),
                              ),
                              onTap: () {
                                // Navigator.of(context).pop();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => screen()),
                                // );


                                showAlertBoxLogout();


                              },
                            ),
                          ],
                        ))),
              ),
            ],
          ),
        ),

        body: [
          homeMain(key: homeKey,),
          pastperform(),
          product(),
          report(),
          about(),

        ][_selectedIndex],

      //),

    );
  }

}

class CustomPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 600,
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Container(
                height: 40,
                color: Colors.grey.shade200,
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Disclaimer & Disclosure',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40,bottom: 60.0),
              child: SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                SizedBox(height: 16.0),
                // Add your scrollable content here
                const SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text("This report has been prepared by PROFITMART SECURITIES PRIVATE LIMITED (hereinafter referred to as PSPL) to provide information about the company(ies) and/sector(s), if any, covered in the report and may be distributed by it and/or its affiliated company(ies). This report is for personal information of the selected recipient/s and does not construe to be any investment, legal or taxation advice to you. This research report does not constitute an offer, invitation or inducement to invest in securities, stock()s or other investments and PSPL is not soliciting any action based upon it. This report is not for public distribution and has been furnished to you solely for educational purpose and for your general information and should not be reproduced or redistributed to any other person in any form. This report does not constitute a personal recommendation or take into account the particular investment objectives, financial situations, or needs of individual clients. Before acting on any content or advice or recommendation in this report/material, investors should consider whether it is suitable for their particular circumstances and, if necessary, seek professional advice. The price and value of the investments referred to in this material and the income from them may go down as well as up, and investors may realize losses on any investments. Past performance is not a guide for future performance, future returns are not guaranteed and a loss of original capital may occur. We may have business relationships with some companies covered by our Research Department. Investors should assume that PSPL and/or its affiliates are seeking or will seek business from the company or companies that are the subject of this material/report and that the research professionals who were involved in preparing this material may educate investors on investments in such business. Author of this report, research professionals responsible for the preparation of this document may interact with trading desk personnel, sales personnel and other parties for the purpose of gathering, applying and interpreting information. Our research professionals are paid on the profitability of PSPL which may include earnings from broking and other business. PSPL generally prohibits its analysts, persons reporting to analysts, and members of their households from maintaining a financial interest in the securities or derivatives of any companies that the analysts cover. Additionally, PSPL generally prohibits its analysts and persons reporting to analysts from serving as an officer, director, or advisory board member of any companies that the analysts cover. Our salespeople, traders, and other professionals or affiliates may provide oral or written market commentary or trading strategies to our clients that reflect opinions that are contrary to the opinions expressed herein. In reviewing these materials, you should be aware that any or all of the foregoing among other things, may give rise to real or potential conflicts of interest. PSPL and its affiliated company(ies), their directors and employees and their relatives may; (a) from time to time, have a long or short position in, act as principal in, and buy or sell the securities or derivatives thereof of companies mentioned herein. (b) be engaged in any other transaction involving such securities and earn brokerage or other compensation or act as a market maker in the financial instruments of the company(ies) discussed herein or act as an advisor or lender/borrower to such company(ies) or may have any other potential conflict of interests with respect to any recommendation and other related information and opinions.; however the same shall have no bearing whatsoever on the specific recommendations made by the analyst(s), as the recommendations made by the analyst(s) are completely independent of the views of the affiliates of PSPL even though there might exist an inherent conflict of interest in some of the stocks mentioned in the research report Reports based on technical and derivative analysis center on studying charts company’s price movement, outstanding positions and trading volume, as opposed to focusing on a company’s fundamentals and, as such, may not match with a report on a company’s fundamental analysis. Unauthorized disclosure, use, dissemination or copying (either whole or partial) of this information, is prohibited. The person accessing this information specifically agrees to exempt PSPL or any of its affiliates or employees from, any and all responsibility/liability arising from such misuse and agrees not to hold PSPL or any of its affiliates or employees responsible for any such misuse and further agrees to hold PSPL or any of its affiliates or employees free and harmless from all losses, costs, damages, expenses that may be suffered by the person accessing this information due to any errors and delays. The information contained herein is based on publicly available data or other sources believed to be reliable. Any statements contained in this report attributed to a third party represent PSPL’s interpretation of the data, information and/ or opinions provided by that third party either publicly or through a subscription service, and such use and interpretation have not been reviewed by the third party. This Report is not intended to be a complete statement or summary of the securities, markets or developments referred to in the document. While we would endeavor to update the information herein on reasonable basis, PSPL and/or its affiliates are under no obligation to update the information. Also there may be regulatory, compliance, or other reasons that may prevent PSPL and/or its affiliates from doing so. PSPL or any of its affiliates or employees shall not be in any way responsible and liable for any loss or damage that may arise to any person/entity from any inadvertent error in the information contained in this report. PSPL or any of its affiliates or employees do not provide, at any time, any express or implied warranty of any kind, regarding any matter pertaining to this report, including without limitation the implied warranties of merchantability, fitness for a particular purpose, and non-infringement. The recipients of this report should rely on their own investigations. This report is intended for distribution to clients/customers, employees and associates of PSPL. Recipients of this report should seek advice of their independent financial advisor prior to taking any investment decision based on this report or for any necessary explanation of its contents. PSPL and it’s associates may have managed or co-managed public offering of securities and/or may have received compensation for brokerage services, may have received any compensation for products or services other than brokerage services from the subject company in the past 12 months. PSPL and it’s associates, research person(s), author of this report have not received any compensation or other benefits from the subject company or third party in connection with this research report. Subject Company may have been a client of PSPL or its associates during twelve months preceding the date of distribution of the research report PSPL and/or its affiliates and/or employees may have interests/positions, financial or otherwise of over 1 % at the end of the month immediately preceding the date of publication of the research in the securities mentioned in this report. To enhance transparency, PSPL has incorporated a Disclosure of Interest Statement in this document. This should, however, not be treated as endorsement of the views expressed in the report. "),
                      SizedBox(height: 5,),
                      Text('bCertification by Analyst(s), Author of this Report', style: TextStyle(fontWeight:FontWeight.w600),),
                      SizedBox(height: 5,),
                      Text('The views expressed in this report accurately reflect the personal views of the analyst(s), author of this report about the subject securities or issues, and no part of the compensation of the research analyst(s), author of this report was, is, or will be directly or indirectly related to the specific recommendations and views expressed by research analyst(s), author of this report; in this report. The research analyst()s, author of this report, strategists, or research associates principally responsible for preparation of this report and/or for any other PSPL research report/material; receive compensation based upon various factors, including quality of research, investor client feedback, stock picking, competitive factors and firm revenues.'),
                      SizedBox(height: 5,),
                      Text('Disclosure of Interest Statement where there is interest in Stocks, Companies mentioned in this report.',style: TextStyle(fontWeight:FontWeight.w600),),
                      SizedBox(height: 5,),
                      Text('Ownership of the stock(s), company (ies) that are mentioned in this report by Analyst(s), author of this report – No'),
                      SizedBox(height: 5,),
                      Text('Analyst(s), author of this report served as an officer, director or employee of Companies mentioned in this report'" - No",),
                      SizedBox(height: 5,),
                      Text('SEBI Registration Number – INH000005582  as per SEBI (Research Analysts) Regulations, 2014.', style: TextStyle(fontWeight:FontWeight.w600),),



                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                // RaisedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text('Close'),
                // ),

              ],
                ),
          ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 520),
              child: Container(
                color: Colors.black,
                height: 35,
                width: double.infinity,
                child: TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text("Close", style: TextStyle(color: Colors.white),)),
              ),
            ),
      ],
        ),
      ),
    );
  }
}

