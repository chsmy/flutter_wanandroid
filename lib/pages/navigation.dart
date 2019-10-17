import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wanandroid/common/webview_plugin.dart';
import 'package:flutter_wanandroid/module/classify.dart';
import 'package:flutter_wanandroid/pages/project.dart';
import 'package:flutter_wanandroid/service/http_request.dart';

import 'article_list_wrap.dart';
import 'mine.dart';

//导航页面
class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  Future _future;

  @override
  void initState() {
    _future = _getItemData();
    super.initState();
  }

  Future _getItemData() {
    return requestGet(UrlPath['navi']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('导航'),
        centerTitle: true,
      ),
      drawer: MinePage(),
      body: Container(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              ClassifyBean classifyBean = ClassifyBean.fromJson(data);
              classifyBean.data[0].isClicked = true;
              return Row(
                children: <Widget>[
                  LeftNav(
                    list: classifyBean.data,
                  ),
                  RightContent(
                    list: classifyBean.data[0].articles,
                  )
                ],
              );
            } else {
              return Center(
                child: Text('加载中...'),
              );
            }
          },
        ),
      ),
    );
  }
}

class LeftNav extends StatefulWidget {
  final List<Data> list;

  LeftNav({this.list});

  @override
  _LeftNavState createState() => _LeftNavState(list: list);
}

class _LeftNavState extends State<LeftNav> {
  final List<Data> list;

  _LeftNavState({this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(260),
      child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: _listItemBuilder,
          itemCount: list.length),
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          for (int i = 0; i < list.length; i++) {
            if (i == index) {
              list[i].isClicked = true;
            } else {
              list[i].isClicked = false;
            }
          }
        });
      },
      child: Container(
        color: list[index].isClicked ? Colors.white : Colors.grey,
        padding: EdgeInsets.all(10.0),
        child: Text(list[index].name),
      ),
    );
  }
}

class RightContent extends StatelessWidget {
  final List<Article> list;

  RightContent({this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
      width: ScreenUtil().setWidth(800),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10.0,
          children: list.map((item) {
            return ActionChip(
              label: Text(item.title,style: TextStyle(color: tagColors[Random().nextInt(tagColors.length)]),),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>WebViewPage(
                      url: item.link,
                      title: item.title,)
                ));
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
