//
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:profit_mart/data_pdf.dart';
//
// import 'get.dart';
//
// class callApiPdf{
//   Future<List<Pdf>>getPdf() async{
//     var client=http.Client();
//
//     var uri=Uri.parse('https://ekyc.profitmart.in:46036/notificationadmin/pdf?items=&link=');
//     debugPrint("pdf1234 : " + uri.toString());
//     var response=await client.get(uri);
//     if(response.statusCode==200){
//       var json=response.body;
//       print('pdf : ' + json);
//       return pdfFromJson(json);
//     }else{
//       return pdfFromJson(json.toString());
//     }
//
//   }
// }