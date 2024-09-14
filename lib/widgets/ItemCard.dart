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

  const ItemCard({super.key, 
    required this.name,
    required this.category,
    required this.locationFound,
    required this.timeFound,
    required this.claimed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double imageSize =
        MediaQuery.of(context).size.width * (isPortrait ? 0.2 : 0.15);

    double fontSize =
        MediaQuery.of(context).size.width * (isPortrait ? 0.027 : 0.0103);

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
          margin: const EdgeInsets.all(1),
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
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
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
                    decoration: const BoxDecoration(
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
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
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            locationFound,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
