import 'package:campus_lost_n_found/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  User? user = FirebaseAuth.instance.currentUser;

  Widget initialRoute;
  if (isLoggedIn && user != null) {
    initialRoute = HomePage(user: user);
  } else {
    initialRoute = const LoginScreen();
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Widget initialRoute;
  // final bool isLoggedIn;

  const MyApp({Key? key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Lost n Found',
      home: initialRoute,
      theme: ThemeData(fontFamily: "ProductSans"),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
