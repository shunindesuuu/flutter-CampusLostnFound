import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final String category;
  final String locationFound;
  final Timestamp timeFound;
  final bool claimed;
  final List<dynamic>? image;

  ItemCard({
    required this.name,
    required this.category,
    required this.locationFound,
    required this.timeFound,
    required this.claimed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null && image!.isNotEmpty)
            Image.network(
              image![0],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Category: $category',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Location Found: $locationFound',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Time Found: ${timeFound.toDate()}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Claimed: ${claimed ? 'Yes' : 'No'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
