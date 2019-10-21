import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/pages/index.dart';
import 'package:flutter_wanandroid/provider/classify_provider.dart';
import 'package:flutter_wanandroid/provider/login_provider.dart';
import 'package:provider/provider.dart';
import './pages/index.dart';
void main() => runApp(MultiProvider(child: MyApp(),providers: [
  ChangeNotifierProvider(builder: (_) => CategoryNavListProvide()),
  ChangeNotifierProvider(builder: (_) => LoginProvider()),
],));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    ));
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
