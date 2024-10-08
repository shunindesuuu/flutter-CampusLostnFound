import 'package:flutter/material.dart';

class ItemDetailPage extends StatelessWidget {
  final String name;
  final String category;
  final String locationFound;
  final DateTime timeFound;
  final bool claimed;
  final List<dynamic>? images;

  const ItemDetailPage({super.key, 
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
        title: const Text('Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images != null && images!.isNotEmpty)
              SizedBox(
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
            const SizedBox(height: 20),
            Card(
              color: Colors.blue[800],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(52, 148, 233, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: claimed
                                ? const Color.fromRGBO(95, 183, 99, 1)
                                : const Color.fromRGBO(255, 0, 0, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            claimed ? 'Claimed' : 'Unclaimed',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Location Found: $locationFound',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Time Found: ${timeFound.day}/${timeFound.month}/${timeFound.year} ${timeFound.hour}:${timeFound.minute}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
