import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../pages/petScreenDetails.dart';
import 'guest_user_filter.dart';
import '../pages/info.dart';

class GuestUser extends StatefulWidget {
  static final String guestScreen = '/guest_user';

  const GuestUser({super.key});

  @override
  State<GuestUser> createState() => _GuestUserState();
}

String searchQuery = '';

class _GuestUserState extends State<GuestUser> {
  static List<Map<String, dynamic>> pets = [];
  bool isLoading = true; // Track loading state

  // Fetch pets data from the API
  Future fetchPets() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/api/pets'));

      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> responseList = json.decode(response.body);
          pets = List<Map<String, dynamic>>.from(responseList);
          isLoading = false; // Set loading state to false once data is fetched
        });
      } else {
        setState(() {
          isLoading = false; // Set loading to false even if request fails
        });
        throw Exception('Failed to load Pets');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false on error
      });
      print('Error $e');
    }
  }

  // Filter pets based on the search query
  List<Map<String, dynamic>>? filterPets({required String query}) {
    if (pets.isEmpty) {
      return []; // Return empty list instead of null
    }

    if (query.isEmpty) {
      return pets; // Return all pets if no search query is provided
    }

    List searchQuery = query.toLowerCase().split(' ');
    return pets.where((pet) {
      String petData =
          '${pet['name'] ?? ''} ${pet['breed'] ?? ''} ${pet['place'] ?? ''} ${pet['age'] ?? ''}'
              .toLowerCase();
      return searchQuery.every((item) => petData.contains(item));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchPets(); // Fetch pets when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayPets =
        filterPets(query: searchQuery) ?? [];

    // Show loading spinner while waiting for pets data
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
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
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Info.info_screen);
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
        body: const Center(
            child: CircularProgressIndicator()), // Display a loading indicator
      );
    }

    // Return the main content after pets have been fetched
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
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
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Info.info_screen);
              },
              icon: const Icon(
                Icons.info_outline,
                size: 35,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Carousel view at the top
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                // Height of the carousel
                aspectRatio: 16 / 9,
                // Aspect ratio of each item
                viewportFraction: 0.8,
                // Fraction of the viewport each item occupies
                enlargeCenterPage: true,
                // Enlarge the center item
                enlargeFactor: 0.3,
                // Amount to enlarge the center item
                autoPlay: true,
                // Enable auto-scrolling
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              items: displayPets.map((pet) {
                return Builder(
                  builder: (BuildContext context) {
                    return _carouselPetCard(
                      image: pet['imageUrl'],
                      name: pet['name'] ?? 'Unknown',
                      breed: pet['breed'] ?? 'Unknown',
                      age: pet['age'] ?? 0,
                      place: pet['place'] ?? pet['location'] ?? 'Unknown',
                      context: context,
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16), // Space between carousel and grid
            // Grid view for the rest of the pets
            displayPets.isEmpty
                ? const Center(child: Text('No pets found.'))
                : Expanded(
                    child: GridView.builder(
                      itemCount: displayPets.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing: 8, // Space between columns
                        mainAxisSpacing: 8, // Space between rows
                        childAspectRatio: 0.8, // Adjust size ratio of each item
                      ),
                      itemBuilder: (context, index) {
                        final pet = displayPets[index];
                        return _petCard(
                          image: pet['imageUrl'],
                          name: pet['name'] ?? 'Unknown',
                          breed: pet['breed'] ?? 'Unknown',
                          age: pet['age'] ?? 0,
                          place: pet['place'] ?? pet['location'] ?? 'Unknown',
                          context: context,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// Carousel pet card widget
Widget _carouselPetCard({
  required dynamic image,
  required String name,
  required String breed,
  required dynamic age,
  required String place,
  required BuildContext context,
}) {
  // Handle potential null values for image and age
  String imageUrl = '';
  if (image != null && image.toString().isNotEmpty) {
    // Extract just the filename from the URL
    String originalUrl = image.toString();
    String filename = originalUrl.split('/').last;

    // Create a new URL pointing to our proxy endpoint
    imageUrl = 'http://10.0.2.2:5000/api/pets/image/$filename';
  }

  final int petAge = age is int ? age : 0;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetDetailsScreen(
            image: imageUrl,
            name: name,
            breed: breed,
            age: petAge,
            place: place,
            petId: '',
            refreshPets: () {},
          ),
        ),
      );
    },
    child: Stack(
      children: [
        // Background image
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image));
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
              : const Center(child: Icon(Icons.pets)),
        ),
        // Gradient overlay for text
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        // Pet information
        Positioned(
          bottom: 16,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '$breed • $petAge years old',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                '📍$place',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Pet card widget
Widget _petCard({
  required dynamic image,
  required String name,
  required String breed,
  required dynamic age,
  required String place,
  required BuildContext context,
}) {
  // Handle potential null values for image and age
  String imageUrl = '';
  if (image != null && image.toString().isNotEmpty) {
    // Extract just the filename from the URL
    String originalUrl = image.toString();
    String filename = originalUrl.split('/').last;

    // Create a new URL pointing to our proxy endpoint
    imageUrl = 'http://10.0.2.2:5000/api/pets/image/$filename';
  }

  final int petAge = age is int ? age : 0;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetDetailsScreen(
            image: imageUrl,
            name: name,
            breed: breed,
            age: petAge,
            place: place,
            petId: '',
            refreshPets: () {},
          ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container with fixed aspect ratio
          AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image));
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )
                  : const Center(child: Icon(Icons.pets)),
            ),
          ),
          // Pet information with padding
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      breed,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(' • '),
                    Text(
                      "$petAge",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '📍$place',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
