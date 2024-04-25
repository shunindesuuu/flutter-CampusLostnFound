import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_n_found/pages/itemdetail.dart';

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
    // Determine if the device is in portrait or landscape mode
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Calculate the image size based on the screen width
    double imageSize =
        MediaQuery.of(context).size.width * (isPortrait ? 0.6 : 0.1);

    // Adjust the font size based on the screen width
    double fontSize =
        MediaQuery.of(context).size.width * (isPortrait ? 0.04 : 0.012);

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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          margin: EdgeInsets.all(1),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            // Set a minimum height if needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                if (image != null && image!.isNotEmpty)
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(image![0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Location Found: $locationFound',
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.blue[800]),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Time Found: ${timeFound.toDate()}',
                        style: TextStyle(
                            fontSize: fontSize, color: Colors.blue[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
