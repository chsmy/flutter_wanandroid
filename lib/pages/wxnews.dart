import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/home.dart';
import 'package:flutter_wanandroid/pages/mine.dart';
import 'package:flutter_wanandroid/pages/wxnews_detail.dart';
import 'package:flutter_wanandroid/service/http_request.dart';

//公众号
class WxNewsPage extends StatefulWidget {
  @override
  _WxNewsPageState createState() => _WxNewsPageState();
}

class _WxNewsPageState extends State<WxNewsPage> {

  Future _future;
  @override
  void initState() {
    _future =  _getTabsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context,snapshot){
        var data=json.decode(snapshot.data.toString());
        if(snapshot.hasData){
          List items = data['data'];
          return DefaultTabController(
            length: items.length,
            child: Scaffold(
              appBar: AppBar(
                  title: Text('公众号'),
                  centerTitle: true,
                  bottom: _getItemTabs(items)
              ),
              body: TabBarView(
                children: _getItemPages(items),
              ),
            ),
          );
        }else{
          return Center(
            child: Text('加载中...'),
          );
        }
      },
    );
  }
  Future _getTabsData() {
     return requestGet(UrlPath['wxarticle']);
  }
  //顶部tab
  Widget _getItemTabs(List items) {
     return TabBar(
       isScrollable: true,
       tabs: items.map((data){
         return Tab(child: Text(data['name']),);
       }).toList(),
     );
  }
  //每个tab页面
  List<Widget> _getItemPages(List items){
    return items.map((item){
        return WxNewsDetail(item['id']);
    }).toList();
  }
}
