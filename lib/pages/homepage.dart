import 'package:campus_lost_n_found/widgets/ItemCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, ${user != null ? user!.displayName ?? "Guest" : "Guest"}',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('items').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var item = doc.data() as Map<String, dynamic>;
                    return ItemCard(
                      name: item['name'],
                      category: item['category'],
                      locationFound: item['location_found'],
                      timeFound: item['time_found'],
                      claimed: item['claimed'],
                      image: item['image'],
                    );
                  }).toList(),
                );
              },
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text('Sign Out'),
            ),
          ),
        ],
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
