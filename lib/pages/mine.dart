import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/provider/login_provider.dart';
import 'package:provider/provider.dart';
//我的信息
class MinePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    String userName = Provider.of<LoginProvider>(context,listen: false).userName;
    debugPrint("userName:$userName");
    return  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          //头部用户信息
          UserAccountsDrawerHeader(
            //圆形头像
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("http://b-ssl.duitang.com/uploads/item/201712/22/20171222223729_d8HCB.jpeg"),
            ),
            accountName: Text(userName??"CHS",style: TextStyle(color: Colors.black),),
            accountEmail: Text("${userName??"chs"}@163.com",style: TextStyle(color: Colors.black87),),
            //设置头部背景
            decoration: BoxDecoration(
              color: Colors.blue[400],
              //网络图片
              image: DecorationImage(image: NetworkImage("https://c-ssl.duitang.com/uploads/item/201408/07/20140807205323_8KxNf.jpeg"),
                  //填充样式
                  fit: BoxFit.cover,
                  //颜色滤镜
                  colorFilter: ColorFilter.mode(Colors.blue[400].withOpacity(0.6), BlendMode.hardLight)
              ),
            ),
          ),
          ListTitle(icon: Icons.assessment,title: '我的积分',),
          ListTitle(icon: Icons.favorite,title: '我的收藏',),
          ListTitle(icon: Icons.assignment,title: 'TODO',),
          ListTitle(icon: Icons.account_box,title: '关于我们',),
          ListTitle(icon: Icons.exit_to_app,title: '退出登录',),
        ],
      ),
    );
  }
}

class ListTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  ListTitle({Key key,this.icon,this.title}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              Icon(icon),
              SizedBox(width: 10,),
              Text(title)
            ],
          )
        ],
      ),
    );
  }
}
