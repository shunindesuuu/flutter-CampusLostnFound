import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (user != null)
              Text(
                'Welcome, ${user!.displayName ?? "Guest"}',
                style: TextStyle(fontSize: 24.0),
              )
            else
              Text(
                'Welcome, Guest',
                style: TextStyle(fontSize: 24.0),
              ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      if (GoogleSignIn().currentUser != null) {
        await GoogleSignIn().signOut();
      }

      try {
        await GoogleSignIn().disconnect();
      } catch (e) {
        print('Failed to disconnect on signout: $e');
      }
      await FirebaseAuth.instance.signOut();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      Navigator.pushReplacementNamed(
          context, '/login'); // Navigate back to the login screen
    } catch (error) {
      print("Error signing out: $error");
    }
  }
}
