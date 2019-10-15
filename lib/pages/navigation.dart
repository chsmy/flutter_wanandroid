import 'package:flutter/material.dart';

//导航页面
class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('导航'),centerTitle: true,),
      body: Center(
        child: Text('NavigationPage'),
      ),
    );
  }
}


