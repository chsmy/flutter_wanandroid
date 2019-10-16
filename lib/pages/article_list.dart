import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/webview_plugin.dart';
//文章列表
class ArticleList extends StatelessWidget {

  final List datas;
  ArticleList({Key key,this.datas}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,//解决无限高度问题
          physics: PageScrollPhysics(),
          itemBuilder: _listItemBuilder,
          itemCount: datas.length),
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
                    url: datas[index]['link'],
                    title: datas[index]['title'],)
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(datas[index]['chapterName']),
                    Text(datas[index]['niceShareDate']),
                  ],
                ),
                SizedBox(height: 5,),
                Text(datas[index]['title'],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 18.0),),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(datas[index]['superChapterName']),
                    Icon(Icons.favorite_border,size: 16,)
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