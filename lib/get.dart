import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

List<Post> postFromJson(String str) {
  return List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));
}

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  String msg = "";
  String researcher = "";
  String closedate = "";
  String bpp = "";
  int lastupdatetime = 0;
  double stoploss = 0;
  String clcode = "";
  String cmp = "";
  String bfl = "";
  String bfp = "";
  String mobileos = "";
  String target = "";
  String buysell = "";
  String market = "";
  String call = "";
  String closeratefortarget = "";
  String closerateforcmp = "";
  int days = 0;
  int logid = 0;
  String exchange = "";
  String closerateforsl = "";
  DateTime sendtime = DateTime.now();
  String msgtype = "";
  String status = "";

  Post({
    required this.msg,
    required this.researcher,
    required this.closedate,
    required this.bpp,
    required this.lastupdatetime,
    required this.stoploss,
    required this.clcode,
    required this.cmp,
    required this.bfl,
    required this.bfp,
    required this.mobileos,
    required this.target,
    required this.buysell,
    required this.market,
    required this.call,
    required this.closeratefortarget,
    required this.closerateforcmp,
    required this.days,
    required this.logid,
    required this.exchange,
    required this.closerateforsl,
    required this.sendtime,
    required this.msgtype,
    required this.status,
  });

  Post.fromJson(Map<String, dynamic> json){
    msg = json["msg"] == null ? "" : json["msg"];
    researcher = json["researcher"] == null ? "" : json["researcher"];
    closedate = json["closedate"] == null ? "" : json["closedate"];
    bpp = json["bpp"] == null ? "" : json["bpp"];
    lastupdatetime =
    json["lastupdatetime"] == null ? 0 : json["lastupdatetime"];
    stoploss = json["stoploss"]?.toDouble() == null ? 0 : json["stoploss"];
    clcode = json["clcode"] == null ? "" : json["clcode"];
    cmp = json["cmp"] == null ? "" : json["cmp"];
    bfl = json["bfl"] == null ? "" : json["bfl"];
    bfp = json["bfp"] == null ? "" : json["bfp"];
    mobileos = json["mobileos"] == null ? "" : json["mobileos"];
    target = json["target"] == null ? "" : json["target"];
    buysell = json["buysell"] == null ? "" : json["buysell"];
    market = json["market"] == null ? "" : json["market"];
    call = json["call"] == null ? "" : json["call"];
    closeratefortarget =
    json["closetypefortarget"] == null ? "" : json["closetypefortarget"];
    closerateforcmp =
    json["closetypeforcmp"] == null ? "" : json["closetypeforcmp"];
    days = json["days"] == null ? 0 : json["days"];
    logid = json["logid"] == null ? 0 : json["logid"];
    exchange = json["exchange"] == null ? "" : json["exchange"];
    closerateforsl =
    json["closetypeforsl"] == null ? "" : json["closetypeforsl"];
    sendtime = DateTime.parse(json["sendtime"]);
    msgtype = json["msgtype"] == null ? "" : json["msgtype"];
    status = json["status"] == null ? "" : json["status"];
  }


  Map<String, dynamic> toJson() =>
      {

        "msg": msg,
        "researcher": researcher,
        "closedate": closedate,
        "bpp": bpp,
        "lastupdatetime": lastupdatetime,
        "stoploss": stoploss,
        "clcode": clcode,
        "cmp": cmp,
        "bfl": bfl,
        "bfp": bfp,
        "mobileos": mobileos,
        "target": target,
        "buysell": buysell,
        "market": market,
        "call": call,
        "closeratefortarget": closeratefortarget,
        "closerateforcmp": closerateforcmp,
        "days": days,
        "logid": logid,
        "exchange": exchange,
        "closerateforsl": closerateforsl,
        "sendtime": sendtime.toIso8601String(),
        "msgtype": msgtype,
        "status": status,
      };

getAvg(){
  double avg;
  print('cmp : '+cmp);
  if(cmp.contains('-')) {
    var toString = cmp.split("-");
    String cmpFirst = toString[0];
    String cmpSecond = toString[1];
    double total = (double.parse(cmpFirst) + double.parse(cmpSecond));
    avg = (total / 2);
  } else {
    avg = double.parse(cmp);
  }
  print('cmp : '+cmp+' avg'+avg.toString());
  return avg;
}

getPer(){

  if (closerateforsl != null && closerateforsl != "") {
    double d = double.parse(closerateforsl);
    double e;
    if (buysell == ("sell")) {
      e = getAvg() - d;
    } else {
      e = d - getAvg();
    }


    double perc = 0.00;

    if (e < 0) {
      perc = ((e * -1) / getAvg()) * 100;
    } else {
      perc = (e / getAvg()) * 100;
    }


    String f=perc.toStringAsFixed(2);
    return "($f%)" ;
  }
  else if (closeratefortarget != null && closeratefortarget!= "") {
    double d = double.parse(closeratefortarget);
    double e;
    if (buysell == ("sell")) {
      e = getAvg() - d;
    } else {
      e = d - getAvg();
    }


    double perc = 0.00;

    if (e < 0) {
      perc = ((e * -1) / getAvg()) * 100;
    } else {
      perc = (e / getAvg()) * 100;
    }

    String f=perc.toStringAsFixed(2);
    return "($f%)" ;
  }

  else if (closerateforcmp!= null && closerateforcmp != "") {
    double d = double.parse(closerateforcmp);
    double e;
    if (buysell == ("sell")) {
      e = getAvg() - d;
    } else {
      e = d - getAvg();
    }


    double perc = 0.00;

    if (e < 0) {
      perc = ((e * -1) / getAvg()) * 100;
    } else {
      perc = (e / getAvg()) * 100;
    }

    String f=perc.toStringAsFixed(2);
    return "($f%)" ;
  }

  if(closerateforsl == "" && closeratefortarget== "" && closerateforcmp == ""){
    if(bpp!=null && bpp!=""){
      double d = double.parse(closerateforsl);
      double e;
      if (buysell == ("sell")) {
        e = getAvg() - d;
      } else {
        e = d - getAvg();
      }


      double perc = 0.00;

      if (e < 0) {
        perc = ((e * -1) / getAvg()) * 100;
      } else {
        perc = (e / getAvg()) * 100;
      }

      String f=perc.toStringAsFixed(2);
      return "($f%)" ;
    }
    else if(bfp!=null && bfp!=""){
      double d = double.parse(bfp);
      double e;
      if (buysell == ("sell")) {
        e = getAvg() - d;
      } else {
        e = d - getAvg();
      }


      double perc = 0.00;

      if (e < 0) {
        perc = ((e * -1) / getAvg()) * 100;
      } else {
        perc = (e / getAvg()) * 100;
      }

      String f=perc.toStringAsFixed(2);
      return "($f%)" ;
    }
    else if(bfl!=null && bfl!=""){
      double d = double.parse(bfl);
      double e;
      if (buysell == ("sell")) {
        e = getAvg() - d;
      } else {
        e = d - getAvg();
      }


      double perc = 0.00;

      if (e < 0) {
        perc = ((e * -1) / getAvg()) * 100;
      } else {
        perc = (e / getAvg()) * 100;
      }

      String f=perc.toStringAsFixed(2);
      return "($f%)" ;
    }
    else {
      return "";
    }

  }

}

getvalue(){

  if (closerateforsl != null && closerateforsl != "") {

    double d = double.parse(closerateforsl);

    String f=d.toStringAsFixed(2);
    return f;

  }
  else if (closeratefortarget != null &&
      closeratefortarget!= "") {
    double d = double.parse(closeratefortarget);

    String f=d.toStringAsFixed(2);
    return f;
  }
  else if (closerateforcmp != null &&
      closerateforcmp != "") {

    double d = double.parse(closerateforcmp);

    String f=d.toStringAsFixed(2);
    return f;


  }
  if(closerateforsl == "" && closeratefortarget == "" && closerateforcmp == ""){

    if(bpp!=null && bpp!=""){
      double d = double.parse(bpp);


      String f=d.toStringAsFixed(2);
      return f;



    }
    else if(bfp!=null && bfp!=""){
      double d = double.parse(bfp);

      String f=d.toStringAsFixed(2);
      return f;



    }
    else if(bfl!=null && bfl!=""){
      double d = double.parse(bfl);

      String f=d.toStringAsFixed(2);
      return f;



    }
    else {
      return '';
    }
  }



}


getCloseretforsl(){


  if (closerateforsl != null && closerateforsl != "") {

    double d = double.parse(closerateforsl);
    double e;
    if (buysell==("sell")) {
      e = getAvg() - d;
    } else {
      e = d - getAvg();
    }

    String f=e.toStringAsFixed(2);
    return f;

  }
  else if (closeratefortarget != null &&
      closeratefortarget!= "") {
    double d = double.parse(closeratefortarget);
    double e;
    if (buysell==("sell")) {
      e = getAvg() - d;
    } else {
      e = d - getAvg();
    }

    String f=e.toStringAsFixed(2);
    return f;
  }
  else if (closerateforcmp != null &&
      closerateforcmp != "") {

    double d = double.parse(closerateforcmp);
    double e;
    if (buysell==("sell")) {
      e = getAvg() - d;
    } else {
      e = d - getAvg();
    }

    String f=e.toStringAsFixed(2);
    return f;


  }
  if(closerateforsl == "" && closeratefortarget == "" && closerateforcmp == ""){

    if(bpp!=null && bpp!=""){
      double d = double.parse(bpp);
      double e;
      if (buysell==("sell")) {
        e = getAvg() - d;
      } else {
        e = d - getAvg();
      }

      String f=e.toStringAsFixed(2);
      return f;



    }
    else if(bfp!=null && bfp!=""){
      double d = double.parse(bfp);
      double e;
      if (buysell==("sell")) {
        e = getAvg() - d;
      } else {
        e = d - getAvg();
      }

      String f=e.toStringAsFixed(2);
      return f;



    }
    else if(bfl!=null && bfl!=""){
      double d = double.parse(bfl);
      double e;
      if (buysell==("sell")) {
        e = getAvg() - d;
      } else {
        e = d - getAvg();
      }

      String f=e.toStringAsFixed(2);
      return f;



    }
    else {
      return '';
    }
  }

}



  getStatus() {
    if (closerateforsl != null && closerateforsl != "") {

      return "STOP-LOSS HIT";
    }
    else if (closeratefortarget != null &&
        closeratefortarget!= "") {
      return "TARGET HIT";
    }
    else if (closerateforcmp != null &&
        closerateforcmp != "") {
      return "CLOSED";
    }

    if(closerateforsl == "" && closeratefortarget == "" && closerateforcmp== ""){

      if(bpp!=null && bpp!=""){

        return "BPP";
      }
      else if(bfp!=null && bfp!=""){

        return "BOOK FULL PROFIT";
      }
      else if(bfl!=null && bfl!=""){

        return "BOOK FULL LOSS";
      }
      else {
        return "ACTIVE";
      }
    }
    return "";
  }


}



