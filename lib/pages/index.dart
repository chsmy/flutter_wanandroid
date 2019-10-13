import 'package:flutter/material.dart';
import 'home.dart';
import 'mine.dart';
import 'navigation.dart';
import 'project.dart';
import 'system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//主页面
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('首页')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings_system_daydream),
        title: Text('体系')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.navigation),
        title: Text('导航')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: Text('项目')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text('我的')
    ),
  ];

  final List<Widget> pages = [
    HomePage(),SystemPage(),NavigationPage(),ProjectPage(),MinePage()
  ];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    currentPage = pages[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomTabs,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
            currentPage = pages[index];
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
    );
  }
}

