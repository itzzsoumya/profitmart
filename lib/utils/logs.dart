
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


void writeError(e) {
 // if(ENVIRONMENT != Environment.PROD)
    print(e);
}

void writelog(String msg) {
  //if(ENVIRONMENT != Environment.PROD)
    print(msg);
}
void restApilog(String msg) {
  //if(ENVIRONMENT != Environment.PROD)
    //log(msg);
}

void printLog(msg,[String? tag]) {
  //if(ENVIRONMENT != Environment.PROD)
    print('${DateFormat('HH:mm:ss').format(DateTime.now())} > ${tag??''} : $msg');
}

