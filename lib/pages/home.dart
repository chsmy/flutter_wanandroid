import 'dart:math';

import 'package:dio/dio.dart';
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
   _autoLogin();
    super.initState();
  }

  void _autoLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    String pwd = prefs.getString("password");
    print('username$username pwd:$pwd');
    if(null!=username&&null!=pwd){
      _login(username, pwd);
    }
  }

  void _login(String username,String pwd){
    FormData formData = new FormData.fromMap({
      "username": username,
      "password": pwd,
    });
    requestPost(UrlPath['login'],formData: formData).then((val){
      Provider.of<LoginProvider>(context).setHasLogin(true);
      Provider.of<LoginProvider>(context).setUserName(username);
      print('login success:>>>>>${val}');
    });
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

class HomeList extends StatefulWidget {

  final List homeList;
  HomeList({Key key,this.homeList}):super(key:key);

  @override
  _HomeListState createState() => _HomeListState(homeList);
}

class _HomeListState extends State<HomeList> with SingleTickerProviderStateMixin{
   final List homeList;
  _HomeListState(this.homeList);
   AnimationController animationController;
   Animation animationSize;
   Animation animationColor;
   CurvedAnimation curvedAnimation;

   @override
   void initState() {
     super.initState();
     animationController = AnimationController(
         duration: Duration(milliseconds: 500),
         vsync: this
     );
     //设置插值器  这里使用一个默认的插值器bounceInOut
     curvedAnimation = CurvedAnimation(parent: animationController,curve: Curves.linear);
     animationSize = Tween(begin: 16.0,end: 32.0).animate(curvedAnimation);
     animationColor = ColorTween(begin: Colors.grey,end: Colors.red).animate(curvedAnimation);
     animationController.addStatusListener((status){
       debugPrint('status $status');
       switch (status){
       //动画一开始就停止了
         case AnimationStatus.dismissed:
           break;
       //动画从头到尾都在播放
         case AnimationStatus.forward:
           break;
       //动画从结束到开始倒着播放
         case AnimationStatus.reverse:
           break;
       //动画播放完停止
         case AnimationStatus.completed:
           animationController.reverse();
           break;
       }
     });
   }
   @override
   void dispose() {
     super.dispose();
     animationController.dispose();
   }

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
                    AnimatedBuilder(
                      animation: animationController,
                      builder: (context,child){
                        return InkWell(
                          onTap: (){
                            if(!Provider.of<LoginProvider>(context,listen: false).isAlreadyLogin){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            }else{
                              debugPrint("AnimatedBuilder");
                              animationController.forward();
                            }
                          },
                          child: Icon(Icons.favorite_border,size: animationSize.value,color: animationColor.value,),
                        );
                      },
                    ),
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



