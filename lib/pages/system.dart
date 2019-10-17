import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/project.dart';
import 'package:flutter_wanandroid/pages/wxnews_detail.dart';
import 'package:flutter_wanandroid/service/http_request.dart';

import 'article_list_wrap.dart';
import 'mine.dart';

//体系页面

class SystemPage extends StatefulWidget {
  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  List systemList = [];

  @override
  void initState() {
    _getSystemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('体系'),
        centerTitle: true,
      ),
      drawer: MinePage(),
      body: Container(
        child: SystemList(
          systemList: systemList,
        ),
      ),
    );
  }

  void _getSystemList() {
    requestGet(UrlPath['system']).then((val) {
      var data = json.decode(val.toString());
      setState(() {
        systemList.clear();
        systemList.addAll(data['data']);
      });
    });
  }
}

class SystemList extends StatelessWidget {
  final List systemList;

  SystemList({Key key, this.systemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _listItemBuilder,
      itemCount: systemList.length,
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 5,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            systemList[index]['name'],
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18),
          ),
          TagList(
            list: systemList[index]['children'],
          )
        ],
      ),
    );
  }
}

class TagList extends StatelessWidget {
  final List list;

  TagList({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Wrap(
          spacing: 10.0,
          children: list.map((item){
            return ActionChip(
              label:Text(item['name'],style: TextStyle(color: tagColors[Random().nextInt(tagColors.length)]),),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>ArticleListWrap(id: item['id'],title: item['name'],)
                ));
              },
            );
          }).toList(),
      ),
    );
  }

}
