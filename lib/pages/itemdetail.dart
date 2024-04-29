import 'package:flutter/material.dart';

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
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images != null && images!.isNotEmpty)
              Container(
                height: MediaQuery.of(context).size.width *
                    (MediaQuery.of(context).orientation == Orientation.portrait
                        ? 0.6
                        : 0.3), // Adjusted size based on orientation
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        images![index],
                        width: MediaQuery.of(context).size.width *
                            (MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 0.6
                                : 0.3), // Adjusted size based on orientation
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '$name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(52, 148, 233, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '$category',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: claimed
                        ? Color.fromRGBO(95, 183, 99, 1)
                        : Color.fromRGBO(255, 0, 0, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    '${claimed ? 'Claimed' : 'Unclaimed'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Location Found: $locationFound',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            SizedBox(height: 10),
            Text(
              'Time Found: ${timeFound.day}/${timeFound.month}/${timeFound.year} ${timeFound.hour}:${timeFound.minute}',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
          ],
        ),
      ),
    );
  }
}
