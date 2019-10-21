import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/project_detail.dart';
import 'package:flutter_wanandroid/service/http_request.dart';

import 'mine.dart';

List tagColors = [Colors.blue,Colors.pink[300],Colors.pink[200], Colors.grey,Colors.brown,Colors.cyan,Colors.red[300],
  Colors.purpleAccent,Colors.cyanAccent[700],Colors.red[400]];

//项目页面
class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {

  Future _future;

  @override
  void initState() {
    _future = _getProjectData();
    super.initState();
  }

  Future _getProjectData(){
     return requestGet(UrlPath['project']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('项目'),centerTitle: true,),
      drawer: MinePage(),
      body: FutureBuilder(
        future: _future,
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List list = data['data'];
            return ProjectGridViewBuilder(datas: list,);
          }else{
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      ),
    );
  }
}

class ProjectGridViewBuilder extends StatelessWidget {

  final List datas;

  ProjectGridViewBuilder({this.datas});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: datas.length,
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    return Container(
      child: Card(
        color: tagColors[Random().nextInt(tagColors.length)],
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context)=>ProjectDetail(
                  id: datas[index]['id'],
                  title: datas[index]['name'],)
            ));
          },
          child: Center(
            child: Text(datas[index]['name'],style: TextStyle(fontSize: 17,color: Colors.white),),
          ),
        ),
      ),
    );
  }
}
