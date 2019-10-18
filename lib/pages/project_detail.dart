import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wanandroid/common/webview_plugin.dart';
import 'package:flutter_wanandroid/service/http_request.dart';
import '../service/http_request.dart';

class ProjectDetail extends StatefulWidget {
  final int id;
  final String title;
  ProjectDetail({this.id,this.title});
  @override
  _ProjectDetailState createState() => _ProjectDetailState(id: id,title: title);
}

class _ProjectDetailState extends State<ProjectDetail> {
  final int id;
  final String title;
  int page = 1;
  List projectList=[];
  bool isRefresh = false;
  EasyRefreshController _controller;
  _ProjectDetailState({this.id,this.title});

  @override
  void initState() {
    _controller = EasyRefreshController();
     _getProjectListData();
    super.initState();
  }

  void _getProjectListData(){
    var urlPath = HttpTool.getPath(path: UrlPath['project_detail'],page: page);
    var parama = {
      'cid':id,
    };
    requestGet(urlPath,formData: parama).then((val){
      var data=json.decode(val.toString());
      setState(() {
        if(isRefresh){
          projectList.clear();
        }else{
          page++;
        }
        projectList.addAll(data['data']['datas']);
      });
      _controller.finishRefresh(success: true);
      _controller.finishLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: EasyRefresh(
        controller: _controller,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        child: ProjectDetailList(projectList),
        onRefresh: () async{
          isRefresh = true;
          page = 1;
          _getProjectListData();
        },
        onLoad: () async {
          isRefresh = false;
          _getProjectListData();
        },
      ),
    );
  }
}

class ProjectDetailList extends StatelessWidget {

  final List list;
  ProjectDetailList(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _itembiulder,
      itemCount: list.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
    );
  }

  Widget _itembiulder(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>WebViewPage(
              url: list[index]['link'],
              title: list[index]['title'],)
        ));
      },
      child: Container(
        height: ScreenUtil().setHeight(500),
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20),top: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
            border: BorderDirectional(bottom: BorderSide(color: Colors.grey))
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(740),
              height: double.maxFinite,
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(list[index]['title'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 5,),
                  Text(list[index]['desc'],maxLines: 3,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 5,),
                  Text('${list[index]['author']} ${list[index]['niceShareDate']}',style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.left,),
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(300),
              height: double.maxFinite,
              child: Image.network(list[index]['envelopePic'],fit: BoxFit.fill,),
            )
          ],
        ),
      ),
    );
  }
}
