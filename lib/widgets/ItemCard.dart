import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_n_found/pages/itemdetail.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailPage(
              name: name,
              category: category,
              locationFound: locationFound,
              timeFound: timeFound.toDate(),
              claimed: claimed,
              images: image,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade800, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          margin: EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5,
              ),
              if (image != null && image!.isNotEmpty)
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(image![0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Location Found: $locationFound',
                        style: TextStyle(fontSize: 10, color: Colors.blue[800]),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Time Found: ${timeFound.toDate()}',
                        style: TextStyle(fontSize: 10, color: Colors.blue[800]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
