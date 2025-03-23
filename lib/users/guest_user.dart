import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../petScreen/petScreenDetails.dart';
import 'guest_user_filter.dart';

class GuestUser extends StatefulWidget {
  static final String guestScreen = '/guest_user';

  const GuestUser({super.key});

  @override
  State<GuestUser> createState() => _GuestUserState();
}

String searchQuery = '';

class _GuestUserState extends State<GuestUser> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayPets = filterPets(query: searchQuery);
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
          itemCount: displayPets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 3 items per row
            crossAxisSpacing: 8, // Space between columns
            mainAxisSpacing: 8, // Space between rows
            childAspectRatio: 0.8, // Adjust size ratio of each item
          ),
          itemBuilder: (context, index) {
            final pet = displayPets[index];
            return _petCard(
              image: pet['img'],
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
  required String image,
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
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
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
