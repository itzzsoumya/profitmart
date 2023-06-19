import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart' hide Headers;
import 'package:profit_mart/utils/logs.dart';
import 'package:retrofit/http.dart';
import 'package:http/http.dart' as http;

import 'apis.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://ekyc.profitmart.in:46036/lms/')
abstract class ApiClient {

  factory ApiClient(Dio dio) = _ApiClient;

  @POST('{api}')
  Future<Response?> sso_req(
      Map<String,dynamic> data,
      @Path('api') String api,
      bool urlEncoded,
      [String? authtoken]);

  @POST('{api}')
  @FormUrlEncoded()
  Future<Int8List> getChart(
      @Path('api') String api,
      @Field() String segment, //0-NSEEQ, 1=NSEFO,2=BSE EQ, 3-NSE CDS, 4-MF,6-MCXFNO
      @Field() String period, //0-eod, 1-min, 2-tick
      @Field() String scrip,
      @Field() String from,
      @Field() String to
      );

  @POST('{api}')
  Future<Int8List> get_small_chart(@Body() String data,@Path('api') String api);

  @POST('{api}')
  Future<Response> get_req(@Path('api') String api);

  @POST('{api}')
  Future<Response?> option_chain_req(@Path('api') String api,@Field() String auth);

  @POST('{api}')
  Future<Response?> version_check_req( @Query('data') String data,@Path('api') String api);


  @GET('{api}')
  Future<Response?> appcode_req(@Path('api') String api);
}