import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'homepage.dart'; // Import HomePage widget
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(65, 130, 242, 1.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: InkWell(
                onTap: () {
                  signInWithGoogle(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/glogo.svg',
                      height: 18.0,
                    ),
                    SizedBox(width: 8),
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ProductSans',
                      ),
                      child: Text('Login with AdDU Account'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                signInAnonymously(context);
              },
              child: const Text('Login as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}

void signInWithGoogle(BuildContext context) async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: userCredential.user),
      ),
    );
  } catch (error) {
    print("Error signing in with Google: $error");
    // Handle error gracefully
  }
}

void signInAnonymously(BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: userCredential.user),
      ),
    );
  } catch (error) {
    print("Error signing in anonymously: $error");
    // Handle error gracefully
  }
}
