import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Mapping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
      ),
      onGenerateRoute: appRoutes,
      initialRoute: noticePage,
    );
  }
}
