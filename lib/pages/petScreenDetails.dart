import 'package:flutter/material.dart';

class PetDetailsScreen extends StatelessWidget {
  final String name;
  final String breed;
  final int age;
  final String place;
  final String image;

  const PetDetailsScreen({
    super.key,
    required this.image,
    required this.name,
    required this.breed,
    required this.age,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(name),
      ), // Show pet name in app bar
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: image.isNotEmpty
                        ? Image.network(image)
                        : Center(
                            child: Icon(Icons.pets),
                          ),
                  ),
                ],
              ),
            ),
            Text(name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            // Pet name
            SizedBox(height: 10),
            // Add spacing
            Text("Breed: $breed", style: TextStyle(fontSize: 18)),
            Text("Age: $age", style: TextStyle(fontSize: 18)),
            Text("Location: $place", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
