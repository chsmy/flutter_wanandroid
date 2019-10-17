import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/wxnews_detail.dart';
//通过id寻找 文章列表
class ArticleListWrap extends StatelessWidget {

  final int id;
  final String title;

  ArticleListWrap({this.id,this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          child: WxNewsDetail(pageId: id,),
        )
    );
  }
}
