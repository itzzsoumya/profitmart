import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


String getString(json, tag, [String? _default]) {
  return json.containsKey(tag) ? json[tag] : _default ?? '';
}

class ScripWiseNews {
  String caption = '';
  String co_code = '';
  String date = '';
  String sr_no = '';
  String yrc = '';

  update(dynamic json) {
    try {
      Map<String, dynamic> map = json;
      if (map.containsKey("caption")) this.caption = getString(json,'caption');
      //if (map.containsKey("co_code")) this.co_code = getString(json,'co_code');
      if (map.containsKey("date")) this.date = getString(json,'date');
      //if (map.containsKey("sr_no")) this.sr_no = json['sr_no'];
      //if (map.containsKey("yrc")) this.yrc = getString(json,'yrc');
    } catch (e) {
      debugPrint("$e");
    }
  }

  getDatePart(){
    var l = date.split('T');
    return l[0];
  }
}









