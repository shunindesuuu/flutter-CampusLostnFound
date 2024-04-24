import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_n_found/widgets/ItemCard.dart';

class HomePage extends StatelessWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth ~/ 200; // Adjust 200 according to your card width

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Campus Lost and Found',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
              child: Text(
                'Welcome, ${user != null ? user!.displayName ?? "Guest" : "Guest"}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
            SizedBox(height: 550.0),
            Container(
              color: Colors.red,
              child: ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onTap: () {
                  _signOut(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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

                final items = snapshot.data!.docs.map((doc) {
                  var item = doc.data() as Map<String, dynamic>;
                  return ItemCard(
                    name: item['name'],
                    category: item['category'],
                    locationFound: item['location_found'],
                    timeFound: item['time_found'],
                    claimed: item['claimed'],
                    image: item['image'],
                  );
                }).toList();

                return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
                  },
                );
              },
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

      Navigator.popAndPushNamed(
          context, '/login'); // Navigate back to the login screen
    } catch (error) {
      print("Error signing out: $error");
    }
  }
}
