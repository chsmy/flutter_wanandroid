import "package:dio/dio.dart";
import 'dart:async';
import 'dart:io';

const BaseUrl = 'https://www.wanandroid.com/';

const UrlPath = {
  'homeList' : BaseUrl + 'article/list',//首页列表
  'homeBanner' : BaseUrl + 'banner/json',//轮播图
  'system' : BaseUrl + 'tree/json',//体系
  'wxarticle' : BaseUrl + 'wxarticle/chapters/json',//公众号tab
  'wxarticle_list' : BaseUrl + 'wxarticle/list',//公众号列表
  'project' : BaseUrl + 'project/tree/json',//项目列表
  'project_detail' : BaseUrl + 'project/list',//项目详情列表
  'navi' : BaseUrl + 'navi/json',//导航列表
};

Future requestGet(url,{formData})async{
  try{
//    print('开始获取数据...............');
    Response response;
    Dio dio = new Dio();
    if(formData==null){
      response = await dio.get(url);
    }else{
      response = await dio.get(url,queryParameters: formData);
    }
    print('url：${url}');
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
      response = await dio.post(url);
    }else{
      response = await dio.post(url,data:formData);
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

class HttpTool{
  // 拼接url
  static String getPath({String path: '', int page, String resType: 'json'}) {
    StringBuffer sb = new StringBuffer(path);
    if (page != null) {
      sb.write('/$page');
    }
    if (resType != null && resType.isNotEmpty) {
      sb.write('/$resType');
    }
    return sb.toString();
  }
}
