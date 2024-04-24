import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetailPage extends StatelessWidget {
  final String name;
  final String category;
  final String locationFound;
  final DateTime timeFound;
  final bool claimed;
  final List<dynamic>? images;

  ItemDetailPage({
    required this.name,
    required this.category,
    required this.locationFound,
    required this.timeFound,
    required this.claimed,
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images != null && images!.isNotEmpty)
              Container(
                height: MediaQuery.of(context).size.width * 0.6,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        images![index],
                        width: MediaQuery.of(context).size.width * 0.6,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            Text(
              '$name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Category: $category',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            Text(
              'Location Found: $locationFound',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            Text(
              'Time Found: ${timeFound.toString()}',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            Text(
              'Claimed: ${claimed ? 'Yes' : 'No'}',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
          ],
        ),
      ),
    );
  }
}
