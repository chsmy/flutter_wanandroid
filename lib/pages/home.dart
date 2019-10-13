import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/widget/swiper_diy.dart';
import '../service/http_request.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';

//首页
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
//AutomaticKeepAliveClientMixin可以保存页面的状态，防止点击tab切换页面的时候从新加载
class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  int page = 1;
  List homeList=[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
   _getHomeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home'),),
      //FutureBuilder可以异步更新界面
      body: FutureBuilder(
        future: requestGet('homeBanner'),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            return  EasyRefresh(
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDataList: data['data'],),
                  HomeList(homeList: homeList),
                ],
              ),
              onRefresh: () async{
              },
              onLoad: () async {
              },
            );
          }else{
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      ),
    );
  }
  void _getHomeList(){
    requestGet('homeList').then((val){
      var data=json.decode(val.toString());
      setState(() {
        homeList.addAll(data['data']['datas']);
        page++;
      });
    });
  }
}

class HomeList extends StatelessWidget {

  final List homeList;
  HomeList({Key key,this.homeList}):super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,//解决无限高度问题
          physics:NeverScrollableScrollPhysics(),//禁用滑动事件
          itemBuilder: _listItemBuilder,
          itemCount: homeList.length),
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(homeList[index]['shareUser']),
              Text(homeList[index]['niceShareDate']),
            ],
          ),
          Text(homeList[index]['title']),
          Row(
            children: <Widget>[
              Text(homeList[index]['superChapterName']),
            ],
          )
        ],
      ),
    );
  }
}


