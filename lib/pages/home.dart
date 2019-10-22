import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:flutter_wanandroid/common/webview.dart';
import 'package:flutter_wanandroid/common/webview_plugin.dart';
import 'package:flutter_wanandroid/pages/login.dart';
import 'package:flutter_wanandroid/pages/mine.dart';
import 'package:flutter_wanandroid/provider/login_provider.dart';
import 'package:flutter_wanandroid/widget/swiper_diy.dart';
import 'package:provider/provider.dart';
import '../service/http_request.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';


//首页
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
//AutomaticKeepAliveClientMixin可以保存页面的状态，防止点击tab切换页面的时候从新加载
class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  
  Future _bannerFuture;
  int page = 1;
  List homeList=[];
  bool isRefresh = false;
  EasyRefreshController _controller;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _controller = EasyRefreshController();
    _bannerFuture = _getBannerList();
   _getHomeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('玩安卓'),elevation: 0.0,centerTitle: true,),
      drawer: MinePage(),
      //FutureBuilder可以异步更新界面
      body: FutureBuilder(
        //future一定要放到build外部去初始化，否则每次刷新都会请求网络
        future: _bannerFuture,
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            return  EasyRefresh(
              controller: _controller,
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  SwiperDiy(swiperDataList: data['data'],),
                  HomeList(homeList: homeList),
                ],
              ),
              onRefresh: () async{
                isRefresh = true;
                page = 1;
                _getHomeList();
              },
              onLoad: () async {
                isRefresh = false;
                _getHomeList();
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

  Future _getBannerList(){
    return requestGet(UrlPath['homeBanner']);
  }

  void _getHomeList(){
    var urlPath = HttpTool.getPath(path: UrlPath['homeList'],page: page);
    requestGet(urlPath).then((val){
      var data=json.decode(val.toString());
      setState(() {
        if(isRefresh){
          homeList.clear();
        }else{
          page++;
        }
        homeList.addAll(data['data']['datas']);
      });
      _controller.finishRefresh(success: true);
      _controller.finishLoad();
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
      padding: EdgeInsets.only(left: 5,right: 5),
      child: Card(
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.all(10),
          child: InkWell(
            splashColor: Colors.grey[400],
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=>WebViewPage(
                    url: homeList[index]['link'],
                    title: homeList[index]['title'],)
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(homeList[index]['chapterName']),
                    Text(homeList[index]['niceShareDate']),
                  ],
                ),
                SizedBox(height: 5,),
                Text(homeList[index]['title'],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18.0),),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(homeList[index]['superChapterName']),
                    InkWell(
                      onTap: (){
                        if(!Provider.of<LoginProvider>(context,listen: false).isAlreadyLogin){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }));
                        }else{

                        }
                      },
                      child: Icon(Icons.favorite_border,size: 16,),)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


