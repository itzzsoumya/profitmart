part of 'api_client.dart';

class _ApiClient implements ApiClient {

  final Dio _dio;
  _ApiClient(this._dio);

  @override
  Future<Response?> sso_req(data,api,urlEncoded,[String? authtoken]) async {
    return null;
  }

  @override
  Future<Int8List> getChart(
      @Path('api') String api,
      @Field() String segment, //0-NSEEQ, 1=NSEFO,2=BSE EQ, 3-NSE CDS, 4-MF,6-MCXFNO
      @Field() String period, //0-eod, 1-min, 2-tick
      @Field() String scrip,
      @Field() String from,
      @Field() String to) async {
    final URL = api+'/$segment/$period/$scrip/$from/$to';
    restApilog('URL ${URL}');
    late Uint8List result;
    final response = await http.get(Uri.parse(URL));
    restApilog('RC ${response.statusCode}');
    if (response.statusCode == 200) {
      result = response.bodyBytes;
    }else{
      result = Uint8List(0);
    }
    return Int8List.fromList(result);
  }

  @override
  Future<Int8List> get_small_chart(_data,_url) async {
    restApilog('URL: ${_url}');
    restApilog('REQUEST: ${_data}');
    late Uint8List result;
    final response = await http.post(Uri.parse(_url),body: _data);
    if (response.statusCode == 200) {
      result = response.bodyBytes;
    }else {
      result = Uint8List(0);
    }
    return Int8List.fromList(result);
  }


  @override
  Future<Response> get_req(_api) async {
    restApilog('URL: ${_api}');
    Response? _result;
    try {
      _result = await _dio.get(_api);
      restApilog('RESPONSE($_api): ${jsonEncode(_result.data)}');
    } on DioError catch (e) {
      _print_dio_error_log(e);
    }
    return _result!;
  }

  @override
  Future<Response?> option_chain_req(api,auth) async {
    final _headers = {
      'Authorization': auth,
      'Accept': 'application/json',
      'Content-type': 'application/json'
    };
    restApilog('URL: $api');
    restApilog('Headers: $_headers');
    Response? response;
    try{
      response = await _dio.fetch<String>(
          _setStreamType<String>(Options(
              method: 'GET',
              headers: _headers
          )
              .compose(_dio.options, api)
          )
      );
      //restApilog('$api\nRESPONSE: ${response.data}');
      return response;
    }on DioError catch(e){
      _print_dio_error_log(e);
    }
    return response;
  }

  @override
  Future<Response?> appcode_req(api) async {
    return null;
  }

  _print_dio_error_log(e){
    if (e.response != null) {
      e.response!.data['stat'] = 'Not_Ok';
      restApilog('STATUS: ${e.response?.statusCode}');
      restApilog('DATA: ${e.response?.data}');
      //print('HEADERS: ${e.response?.headers}');
      return e.response;
    } else {
      restApilog('ERROR: ${e.message}');
    }
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }


  @override
  Future<Response?> version_check_req(auth,api) async {
    return null;
  }

// @override
// Future<ResponseData> getUsers() async {
//   const _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   final _data = <String, dynamic>{};
//   final _headers = <String, dynamic>{};
//   final _result = await _dio.request<Map<String, dynamic>>(
//       baseUrl! + Apis.users,
//       queryParameters: queryParameters,
//       options: Options(method: 'GET', headers: _headers, extra: _extra),
//       data: _data);
//   final value = ResponseData.fromJson(_result.data!);
//   return value;
// }
}
