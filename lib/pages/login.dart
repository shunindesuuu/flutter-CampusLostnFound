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
                image: AssetImage("assets/images/bglogin.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/applogo.svg',
                height: 300,
              ),
            ),
          ),
          // Login Container
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 18, 21, 196),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/glogo.svg',
                              height: 18.0,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Login with AdDU Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        signInAnonymously(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 119, 171, 238),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 14, 34, 119),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Login as Guest',
                              style: TextStyle(
                                color: Color.fromARGB(255, 14, 34, 119),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
