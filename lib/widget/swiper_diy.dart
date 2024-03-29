import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:flutter_wanandroid/common/webview.dart';
import 'package:flutter_wanandroid/common/webview_plugin.dart';

//自定义首页轮播图
class SwiperDiy extends StatelessWidget {

  final List swiperDataList;
  SwiperDiy({Key key,this.swiperDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(1080),
      color: Colors.white,
      child: AspectRatio(
        aspectRatio: 2/1,
        child: Swiper(
          itemBuilder: (context,index){
            return InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>WebViewPage(
                      url: swiperDataList[index]['url'],
                      title: swiperDataList[index]['title'],)
                ));
              },
              child: Image.network(swiperDataList[index]['imagePath'],fit: BoxFit.fill,),
            );
          },
          itemCount: swiperDataList.length,
          pagination: SwiperPagination(),
          autoplay: true,
        ),
      ),
    );
  }
}
