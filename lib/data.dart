// class DataChain{
//   String title = '';
//   String icon = '';
//   String call = '';
//   String cmp='';
//   String between = '';
//   String status = '';
//   String exchange = '';
//   String target = '';
//   String value = '';
//   String days = '';
//   String sl = '';
//   String pl = '';
//   String date = '';
//   String time = '';
//   String admin = '';
//
//   DataChain(
//       {required this.title, required this.icon,
//         required this.call,required this.cmp , required this.status,
//         required this.exchange,required this.target, required this.value,
//         required this.days, required this.sl, required this.pl,
//         });
// }


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:profit_mart/utils/GlobalClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get.dart';
import 'package:http/http.dart' as http;

class callApi{

  Future<List<Post>?>getPosts(int lastlogid) async{
    var client=http.Client();
    var uri=Uri.parse('https://ekyc.profitmart.in:46036/notificationadmin/notificationShow?clcode='+GlobalClass.clcode_globalclass +'&lastlogid='+lastlogid.toString()+'&tag=0');
    var response=await client.get(uri);
    if(response.statusCode==200){
      var json = response.body;
      debugPrint(json);
      List<Post> post_list = postFromJson(json);
      if(post_list!=null && post_list.length>0) {
        save_to_shared_pref(json, post_list.last.logid);
      }
      return postFromJson(json);
    }
  }

  Future<void> save_to_shared_pref(String json,int logid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notification_list', json);
    prefs.setInt('logid', logid);
  }



  Future<List<Post>?> get_from_shared_pref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonStr = prefs.getString('notification_list')!;
    return postFromJson(jsonStr);
  }
  Future<int> get_from_shared_pref_logid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var logid = prefs.getInt('logid')!;
    //print('get_from_shared_pref: $jsonStr');
    return logid as int;
  }

  Future<void> setOtpVerifiedTag(bool b) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('otpVerified', b);
  }




  Future<bool> getOtpVerifiedTag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login = prefs.getBool('otpVerified')??false;
    String? clcode = prefs.getString('clcode');
    print('clcode123 : '+clcode.toString());
    GlobalClass.clcode_globalclass=clcode.toString();
    return login;
  }

  // Future<bool> getOtpVerifiedTag() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool login = prefs.getBool('otpVerified')??false;
  //   return login;
  // }





  // Future<void> setOtpVerifiedMob(String mob) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('mobileNo', mob);
  // }
  //
  // Future<String?>getStringValuesMobileNo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? mobNo = prefs.getString('mobileNo');
  //   return mobNo;
  // }
  //
  //
  Future<void> save_to_shared_pref_clcode(String clcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('clcode', clcode);
  }
  //
  // Future<String?>get_save_to_shared_pref_clcode() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? clcode = prefs.getString('clcode');
  //   return clcode;
  // }

}