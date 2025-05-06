import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fureverhome/colors/appColors.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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

          ///Local
          // await http.get(Uri.parse('http://10.0.2.2:5000/api/pets'));
          await http
              .get(Uri.parse('https://ccc-151-backend.onrender.com/api/pets'));

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

    //responsive text
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScale =
        screenWidth / 360; // base size from common width of phone

    // Show loading spinner while waiting for pets data
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.creamWhite,
          //elevation: 0,
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
                      hintStyle:
                      TextStyle(color: AppColors.darkGray.withOpacity(0.7)),
                      prefixIcon:
                      const Icon(Icons.search, color: AppColors.darkGray),
                      contentPadding: const EdgeInsets.symmetric(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: AppColors.gold),
                      ),
                      filled: true,
                      fillColor: AppColors.white,
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
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: AppColors.paleBeige,
          child: Column(
            children: [
              // Disclaimer at the top with padding
              Container(
                color: AppColors.gold.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 12 * textScale,
                      ),
                      children: [
                        TextSpan(
                            text: 'Disclaimer:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text: ' This is beta version. Report a problem via '),
                        TextSpan(
                          text: 'feedback form',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 12 * textScale,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Open Google Forms feedback form in browser
                              launchUrl(
                                Uri.parse('https://forms.gle/Piyb7XTnhpGAdHbo9'),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                        ),
                        TextSpan(text: '!')
                      ],
                    ),
                  ),
                ),
              ),
              // Center the spinner in the remaining space
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Return the main content after pets have been fetched
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        // Using creamWhite from new palette
        elevation: 0,
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
                    hintStyle:
                        TextStyle(color: AppColors.darkGray.withOpacity(0.7)),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.darkGray),
                    contentPadding: const EdgeInsets.symmetric(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppColors.gold),
                    ),
                    filled: true,
                    fillColor:
                        AppColors.white, // White background for the text field
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
                color: AppColors.darkGray, // Dark gray icon
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.paleBeige,
        child: SafeArea(
          child: Column(
            children: [
              // Disclaimer banner
              Container(
                width: double.infinity,
                color: AppColors.gold.withOpacity(0.2),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  children: [
                    //const Icon(Icons.info_outline, size: 16, color: AppColors.darkGray),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 12 * textScale,
                          ),
                          children: [
                            TextSpan(
                                text: 'Disclaimer:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text:
                                    ' This is beta version. Report a problem via '),
                            TextSpan(
                              text: 'feedback form',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 12 * textScale,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Open Google Forms feedback form in browser
                                  launchUrl(
                                    Uri.parse(
                                        'https://forms.gle/Piyb7XTnhpGAdHbo9'),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                            ),
                            TextSpan(text: '!')
                          ],
                        ),
                      ),
                    ),
                    // IconButton(
                    //   padding: EdgeInsets.zero,
                    //   constraints: const BoxConstraints(),
                    //   icon: const Icon(Icons.close, size: 16, color: AppColors.darkGray),
                    //   onPressed: () {
                    //     //TODO
                    //     // Hide the disclaimer
                    //     // Implementation depends on your state management approach
                    //     // For example:
                    //     // setState(() {
                    //     //   showDisclaimer = false;
                    //     // });
                    //   },
                    // ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.01), // Small spacing after disclaimer
              // Carousel
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.29, // 25% of screen height
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: displayPets.map((pet) {
                    return _carouselPetCard(
                      /// If we will not set this no Unknown it will cause error
                      image: pet['imageFileId'],
                      name: pet['name'] ?? 'Unknown',
                      breed: pet['breed'] ?? 'Unknown',
                      age: pet['age'] ?? 0,
                      place: pet['place'] ?? pet['location'] ?? 'Unknown',
                      contactNumber: pet['contactNumber'] ?? 'Unknown',
                      about: pet['about'] ?? 'Unknown',
                      ownerName: pet['ownerName'] ?? 'Unknown',
                      context: context,
                      textScale: textScale,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),

              // Pets Grid
              Expanded(
                child: displayPets.isEmpty
                    ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.pets,
                          size: 64,
                          color: AppColors.gold,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No pets available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please list a Pet',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),)
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: displayPets.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          // 2 columns for phones, 3 for tablets
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7, // Make cards taller
                        ),
                        itemBuilder: (context, index) {
                          final pet = displayPets[index];
                          return _petCard(
                            /// If we will not set this no Unknown it will cause error
                            image: pet['imageFileId'],
                            name: pet['name'] ?? 'Unknown',
                            breed: pet['breed'] ?? 'Unknown',
                            age: pet['age'] ?? 0,
                            place: pet['place'] ?? pet['location'] ?? 'Unknown',
                            contactNumber: pet['contactNumber'] ?? 'Unknown',
                            about: pet['about'] ?? 'Unknown',
                            ownerName: pet['ownerName'] ?? 'test',
                            context: context,
                            textScale: textScale,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Carousel pet card widget
Widget _carouselPetCard(
    {required dynamic image,
    required String name,
    required String breed,
    required dynamic age,
    required String place,
    required String contactNumber,
    required String about,
    required String ownerName,
    required BuildContext context,
    required double textScale}) {
  // Handle potential null values for image and age
  String imageUrl = '';
  if (image != null && image.toString().isNotEmpty) {
    // Extract just the filename from the URL
    // String originalUrl = image.toString();
    // String filename = originalUrl.split('/').last;

    // Create a new URL pointing to our proxy endpoint
    imageUrl = 'https://ccc-151-backend.onrender.com/api/pets/image/$image';
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
            contactNumber: contactNumber,
            about: about,
            ownerName: ownerName,
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
                    return const Center(
                        child: Icon(Icons.broken_image,
                            color: AppColors.darkGray));
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.gold, // Gold spinner
                      ),
                    );
                  },
                )
              : const Center(
                  child: Icon(Icons.pets, color: AppColors.darkGray)),
        ),
        // Gradient overlay for text
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                AppColors.darkBlueGray.withOpacity(0.7),
                Colors.transparent
              ],
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
                style: TextStyle(
                  fontSize: 18 * textScale,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '$breed • $petAge years old',
                style: TextStyle(
                  fontSize: 12 * textScale,
                  color: Colors.white,
                ),
              ),
              Text(
                '📍$place',
                style: TextStyle(
                  fontSize: 10 * textScale,
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
Widget _petCard(
    {required dynamic image,
      required String name,
      required String breed,
      required dynamic age,
      required String place,
      required String about,
      required String ownerName,
      required String contactNumber,
      required BuildContext context,
      required double textScale}) {
  // Handle potential null values for image and age
  String imageUrl = '';
  if (image != null && image.toString().isNotEmpty) {
    // Extract just the filename from the URL
    // String originalUrl = image.toString();
    // String filename = originalUrl.split('/').last;

    // Create a new URL pointing to our proxy endpoint
    imageUrl = 'https://ccc-151-backend.onrender.com/api/pets/image/$image';
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
            contactNumber: contactNumber,
            about: about,
            ownerName: ownerName,
            petId: '',
            refreshPets: () {},
          ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.creamWhite, // Using creamWhite from new palette
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueGray.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2), // little shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container without aspect ratio
          AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.center,
                // Ensure the image takes the full width
                //height: 150,
                // Set a fixed height for the image
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.broken_image,
                          color: AppColors.darkGray));
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.gold, // Gold spinner
                    ),
                  );
                },
              )
                  : const Center(
                  child: Icon(Icons.pets, color: AppColors.darkGray)),
            ),
          ),
          // Pet information with reduced padding
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Pet name
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 17 * textScale,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray, // Dark gray text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4),
                // Reduced spacing between name and breed/age
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$breed • $petAge years old',
                          style: TextStyle(
                              fontSize: 15 * textScale,
                              color: AppColors.darkGray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Text(' • '),
                    // Flexible(
                    //   child: FittedBox(
                    //     fit: BoxFit.scaleDown,
                    //     child: Text(
                    //       "$petAge years old",
                    //       style: TextStyle(
                    //           fontSize: 15 * textScale,
                    //           color: AppColors.darkGray),
                    //       maxLines: 1,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 4),
                // Reduced spacing between breed/age and place
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '📍$place',
                    style: TextStyle(
                        fontSize: 14 * textScale,
                        color: AppColors.darkBlueGray),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

