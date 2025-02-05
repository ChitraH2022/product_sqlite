import 'package:flutter/material.dart';
import 'package:product_sqlite/screen/crudScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'soft drinks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CrudScreenPage(),
    );
  }
}