import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GlgwangApis{
  GlgwangApis([this.context]){
    _options = Options(extra: {'context':context});
  }
  BuildContext context;
  Options _options;

  Dio dio = new Dio(BaseOptions(
    baseUrl: 'baseUrl',
    headers: {
      HttpHeaders.acceptHeader:"application/json"
    }
  ));
  
  Future getShop({data}) async{
    var response = await dio.post('/shop',data: data,options: _options);
    return jsonDecode(response.toString());
  }
  Future getBanner({data}) async{
    var response = await dio.post('/banner',data:data,options:_options); 
    return jsonDecode(response.toString());
  }
  //  首页现货行情
  Future spotMarket({data}) async{
    var response = await dio.post('/spotMarket',data:data,options:_options); 
    return jsonDecode(response.toString());
  }
}
/// dio拦截器
class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    print("REQUEST[${options?.method}] => PATH: ${options?.path}");
    return super.onRequest(options);
  }
  @override
  Future onResponse(Response response) {
    print("RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response);
  }
  @override
  Future onError(DioError err) {
    print("ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}

