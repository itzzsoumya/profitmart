import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';

class AppRepository {
  static final AppRepository instance = AppRepository._privateConstructor();

  factory AppRepository() {
    return instance;
  }

  late ApiClient apiRequest;
  AppRepository._privateConstructor(){
    Dio dio = new Dio(BaseOptions(contentType: "application/json"));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    apiRequest = ApiClient(dio);
  }
}