import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fureverhome/tests/test_data.dart';
import '../petScreen/petScreenDetails.dart';

class GuestUser extends StatefulWidget {
  static final String guestScreen = '/guest_user';

  const GuestUser({super.key});

  @override
  State<GuestUser> createState() => _GuestUserState();
}

String searchQuery = '';


class _GuestUserState extends State<GuestUser> {
  List<Map<String, dynamic>> filterPets({
    String? nameQuery,
    String? breedQuery,
    String? locationQuery,
    int? ageQuery,
  }) {
    return testPets.where((pet) {
      bool matchesName = nameQuery == null ||
          pet['name'].toLowerCase().contains(nameQuery.toLowerCase());
      bool matchesBreed = breedQuery == null ||
          pet['breed'].toLowerCase().contains(breedQuery.toLowerCase());
      bool matchesLocation = locationQuery == null ||
          pet['place'].toLowerCase().contains(locationQuery.toLowerCase());
      bool matchesAge =
          ageQuery == null || pet['age'] == ageQuery; // Exact age match

      return matchesName && matchesBreed && matchesLocation && matchesAge;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.info_outline, size: 35)
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: testPets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 3 items per row
            crossAxisSpacing: 8, // Space between columns
            mainAxisSpacing: 8, // Space between rows
            childAspectRatio: 0.8, // Adjust size ratio of each item
          ),
          itemBuilder: (context, index) {
            final pet = testPets[index];
            return _petCard(
              name: pet['name'],
              breed: pet['breed'],
              age: pet['age'],
              place: pet['place'],
              context: context,
            );
          },
        ),
      ),
    );
  }
}

Widget _petCard({
  required String name,
  required String breed,
  required int age,
  required String place,
  required BuildContext context, // Added context to handle navigation
}) {
  return GestureDetector(
    // Made the entire card clickable
    onTap: () {
      Navigator.push(
        // Navigate to details screen on tap
        context,
        MaterialPageRoute(
          builder: (context) => PetDetailsScreen(
            name: name,
            breed: breed,
            age: age,
            place: place,
          ),
        ),
      );
    },
    child: Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Rounded corners for design
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
          // Add a shadow
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          // Bold pet name
          Text(breed),
          Text("Age: $age"),
          Text(place),
        ],
      ),
    ),
  );
}
