import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'homepage.dart'; // Import HomePage widget
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/addu-ccfc.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/applogo.svg',
                height: 350,
              ),
            ),
          ),
          // Login Container
          Center(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              height: 140,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Login Buttons
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade800,
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
                          const SizedBox(width: 8),
                          const DefaultTextStyle(
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
                  const SizedBox(height: 5.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      signInAnonymously(context);
                    },
                    child: const Text('Login as Guest'),
                  ),
                ],
              ),
            ),
          ),
        ],
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

    saveLoginState(true); // Save login state
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

    saveLoginState(true); // Save login state
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

Future<void> saveLoginState(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}
