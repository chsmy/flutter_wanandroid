import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_wanandroid/service/http_request.dart';

import 'article_list.dart';
//通过id查找文章列表
class WxNewsDetail extends StatefulWidget {
  final int pageId;

  WxNewsDetail({this.pageId});

  @override
  _WxNewsDetailState createState() => _WxNewsDetailState(pageId);
}

class _WxNewsDetailState extends State<WxNewsDetail> {
  final int pageId;

  _WxNewsDetailState(this.pageId);

  List datas = [];
  bool isRefresh = false;
  int page = 1;
  EasyRefreshController _controller;

  @override
  void initState() {
    _controller = EasyRefreshController();
    _getListData();
    super.initState();
  }

  void _getListData() {
      var urlPath = HttpTool.getPath(
        path: UrlPath['wxarticle_list'] + '/${pageId}', page: page);
      requestGet(urlPath).then((val) {
      var data = json.decode(val.toString());
      setState(() {
        if (isRefresh) {
          datas.clear();
        } else {
          page++;
        }
        datas.addAll(data['data']['datas']);
      });
      _controller.finishRefresh(success: true);
      _controller.finishLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      child: ArticleList(
        datas: datas,
      ),
      onRefresh: () async {
        isRefresh = true;
        page = 1;
        _getListData();
      },
      onLoad: () async {
        isRefresh = false;
        _getListData();
      },
    );
  }
}
