import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('登录'),),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(40)),
              Image.asset("images/android.png",height: ScreenUtil().setHeight(400),),
              SizedBox(height: ScreenUtil().setHeight(40)),
              LoginItem()
            ],
          ),
        ),
      ),
    );
  }
}

class LoginItem extends StatefulWidget {
  @override
  _LoginItemState createState() => _LoginItemState();
}

class _LoginItemState extends State<LoginItem> {

  final registerFormKey = GlobalKey<FormState>();
  String username,password;
  bool autovalidate = false;
  void submitRegisterForm() {
    if(registerFormKey.currentState.validate()){
      registerFormKey.currentState.save();
      debugPrint('username:$username');
      debugPrint('password:$password');
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("正在登录....")));
    }else{
      setState(() {
        autovalidate = true;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Container(
          child: Form(
            key: registerFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:InputDecoration(
                    labelText: '用户名',
                  ),
                  onSaved: (value){
                    username = value;
                  },
                  validator: validatorUsername,
                  autovalidate: autovalidate,
                ),
                TextFormField(
                  obscureText: true,
                  decoration:InputDecoration(
                    labelText: '密码',
                  ),
                  onSaved: (value){
                    password = value;
                  },
                  validator: validatorPassword,
                  autovalidate: autovalidate,
                ),
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 0.0,
                      child: Text("登录",style: TextStyle(color: Colors.white),),
                      onPressed: submitRegisterForm),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){},
                    child: Text('注册',style: TextStyle(color: Colors.blue),),
                  ),
                )
              ],
            ),
          )
    );
  }

  String validatorUsername(String value) {
    if(value.isEmpty){
      return '用户名不能为空';
    }
    return null;
  }

  String validatorPassword(String value) {
    if(value.isEmpty){
      return '密码不能为空';
    }
    return null;
  }
}

