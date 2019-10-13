import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

Future requestGet(url,{formData})async{
  try{
//    print('开始获取数据...............');
    Response response;
    Dio dio = new Dio();
    if(formData==null){
      response = await dio.get(UrlPath[url]);
    }else{
      response = await dio.get(UrlPath[url],queryParameters: formData);
    }
    print(UrlPath[url]);
    if(response.statusCode==200){
      return response;
    }else{
      throw Exception('出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }
}
Future requestPost(url,{formData})async{
  try{
//    print('开始获取数据...............');
    Response response;
    Dio dio = new Dio();
    if(formData==null){
      response = await dio.post(UrlPath[url]);
    }else{
      response = await dio.post(UrlPath[url],data:formData);
    }
    print(response);
    if(response.statusCode==200){
      return response;
    }else{
      throw Exception('出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }
}
