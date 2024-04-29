import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_n_found/pages/itemdetail.dart';
import 'package:intl/intl.dart'; // Import the intl package

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

    double imageSize =
        MediaQuery.of(context).size.width * (isPortrait ? 0.2 : 0.15);

    // Adjust the font size based on the screen width
    double fontSize =
        MediaQuery.of(context).size.width * (isPortrait ? 0.04 : 0.0106);

    // Format the date
    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(timeFound.toDate());

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
          color: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (image != null && image!.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 16 /
                        9, // Adjust this value based on your desired aspect ratio
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(image![0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                            fontSize: 34, // Adjust the font size as needed
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900),
                      ),
                    ),
                  ),
                SizedBox(height: 5),
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
                        style:
                            TextStyle(fontSize: fontSize, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Time Found: $formattedDate', // Use the formatted date
                        style:
                            TextStyle(fontSize: fontSize, color: Colors.white),
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
