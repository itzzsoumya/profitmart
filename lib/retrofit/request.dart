import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class GetVersionCheckReq {
  String version = '';

  GetVersionCheckReq({required this.version});

  Map toJson() =>
      {
        'VERSIONCODE': version,
      };

  String get_req_string() {
    String json = jsonEncode(this);
    return "$json";
  }

}