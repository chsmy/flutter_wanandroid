
//导航分类的管理

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/module/classify.dart';

class CategoryNavListProvide with ChangeNotifier{

  List<Article> navList = [];

  //点击大类时更换商品列表
  getNavList(List<Article> list){
    navList=list;
    notifyListeners();
  }
}