import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/pages/index.dart';
import './pages/index.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '玩安卓',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}
