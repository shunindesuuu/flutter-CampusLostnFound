import 'package:campus_lost_n_found/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Midterm Examination',
      routes: {
        '/': (context) => LoginScreen(),
        // '/dashboard':(context) => LayoutBuilder(builder: (context, constraints) {
        //   if (constraints.maxWidth > 600) {
        //   return DashboardScreen();
        // } else {
        //   return MobileDashboardScreen();
        // }
        // }),
      },
    );
  }
}
