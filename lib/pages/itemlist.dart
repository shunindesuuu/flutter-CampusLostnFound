import 'package:campus_lost_n_found/widgets/ItemCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ItemListScreen(),
  ));
}
