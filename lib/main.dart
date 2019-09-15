import 'package:flutter/material.dart';
import 'package:new_login/login_page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
        home: new LoginPage(),
    );
  }
}

