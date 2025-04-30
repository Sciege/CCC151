import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../authentication/auth_registered_users.dart';
import 'package:http/http.dart' as http;
import '../colors/appColors.dart';

class PetDetailsScreen extends StatefulWidget {
  final String name;
  final String breed;
  final int age;
  final String place;
  final String image;
  final bool isEditable;
  final String petId;
  final VoidCallback refreshPets;

  // Added contact information fields
  final String ownerName;
  final String contactNumber;
  final String about;

  const PetDetailsScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.breed,
      required this.age,
      required this.place,
      this.isEditable = false,
      required this.petId,
      required this.refreshPets,
      // Default values for contact info in case they're not provided
      required this.ownerName,
      required this.contactNumber,
      required this.about});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  late String name;
  late String breed;
  late int age;
  late String place;
  late String image;

  // Added contact information fields
  late String ownerName;
  late String contactNumber;
  late String about;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    breed = widget.breed;
    age = widget.age;
    place = widget.place;
    image = widget.image;
    ownerName = widget.ownerName;
    contactNumber = widget.contactNumber;
    about = widget.about;
    // Print statements for debugging
    print('Name: $name');
    print('Breed: $breed');
    print('Age: $age');
    print('Place: $place');
    print('Image: $image');
    print('Owner Name: $ownerName');
    print('Contact Number: $contactNumber');
    print('About: $about');
  }

  void updatePetDetails(Map<String, dynamic> updatedDetails) {
    setState(() {
      name = updatedDetails['name'];
      breed = updatedDetails['breed'];
      age = updatedDetails['age'];
      place = updatedDetails['place'];
      image = updatedDetails['image'];
      ownerName = updatedDetails['ownerName'];
      contactNumber = updatedDetails['contactNumber'];
      about = updatedDetails['about'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: widget.isEditable
        //     ? [
        //         Container(
        //           margin: const EdgeInsets.only(right: 16),
        //           decoration: BoxDecoration(
        //             color: Colors.white.withOpacity(0.3),
        //             borderRadius: BorderRadius.circular(50),
        //           ),
        //           child: IconButton(
        //             icon: const Icon(Icons.edit_rounded, color: Colors.white),
        //             onPressed: () async {
        //               final updatedDetails = await Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (_) => EditPetScreen(
        //                     name: name,
        //                     breed: breed,
        //                     age: age,
        //                     place: place,
        //                     image: image,
        //                     petId: widget.petId,
        //                     refreshPets: widget.refreshPets,
        //                     ownerName: ownerName,
        //                     contactNumber: contactNumber,
        //                     about: about,
        //                   ),
        //                 ),
        //               );
        //               if (updatedDetails != null) {
        //                 updatePetDetails(updatedDetails);
        //               }
        //             },
        //           ),
        //         )
        //       ]
        //     : null,
      ),
      body: Column(
        children: [
          // Hero image with gradient overlay
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.paleBeige,
                          child: const Icon(Icons.pets,
                              size: 100, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: AppColors.paleBeige,
                        child: const Icon(Icons.pets,
                            size: 100, color: Colors.grey),
                      ),
                // Gradient overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                // Pet name at the bottom of the image
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Pet details in cards
          Expanded(
            child: Container(
              color: AppColors.paleBeige,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(
                      Icons.pets_rounded,
                      'Breed',
                      breed,
                      AppColors.paleBeige.withOpacity(0.8),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      Icons.cake_rounded,
                      'Age',
                      '$age years',
                      AppColors.paleBeige.withOpacity(0.8),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      Icons.location_on_rounded,
                      'Location',
                      place,
                      AppColors.paleBeige.withOpacity(0.8),
                    ),
                    const SizedBox(height: 16),
                    // Contact information section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.paleBeige.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.person,
                                    color: Colors.brown),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Contact Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  color: Colors.brown, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Owner: $ownerName',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  color: Colors.brown, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Phone: $contactNumber',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Call button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Redirected to call the Owner
                                final Uri phoneUri =
                                    Uri(scheme: 'tel', path: contactNumber);
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                }
                                // else {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content: Text('Could not launch dialer'),
                                //       backgroundColor: Colors.red,
                                //     ),
                                //   );
                                // }
                              },
                              icon: const Icon(Icons.call),
                              label: const Text('Contact Owner'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Redirected to call the Owner
                                final Uri phoneUri =
                                    Uri(scheme: 'sms', path: contactNumber);
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                }
                                //  else {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content: Text('Could not launch dialer'),
                                //       backgroundColor: Colors.red,
                                //     ),
                                //   );
                                // }
                              },
                              icon: const Icon(Icons.message_outlined),
                              label: const Text('Message Owner'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow[700],
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      //TODO : insert about here
                      about,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.isEditable)
                      ElevatedButton.icon(
                        onPressed: () async {
                          final updatedDetails = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPetScreen(
                                name: name,
                                breed: breed,
                                age: age,
                                place: place,
                                image: image,
                                petId: widget.petId,
                                about: about,
                                ownerName: ownerName,
                                contactNumber: contactNumber,
                                refreshPets: widget.refreshPets,
                              ),
                            ),
                          );
                          if (updatedDetails != null) {
                            updatePetDetails(updatedDetails);
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Pet Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.brown),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditPetScreen extends StatefulWidget {
  final String name;
  final String breed;
  final int age;
  final String place;
  final String image;
  final String petId;
  final VoidCallback refreshPets;

  // Added contact information fields
  final String ownerName;
  final String contactNumber;
  final String about;

  const EditPetScreen({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.place,
    required this.image,
    required this.petId,
    required this.refreshPets,
    required this.ownerName,
    required this.contactNumber,
    required this.about,
  });

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  late TextEditingController nameController;
  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController placeController;

  // Added contact information controllers
  late TextEditingController ownerNameController;
  late TextEditingController contactNumberController;
  late TextEditingController aboutController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    breedController = TextEditingController(text: widget.breed);
    ageController = TextEditingController(text: widget.age.toString());
    placeController = TextEditingController(text: widget.place);
    ownerNameController = TextEditingController(text: widget.ownerName);
    contactNumberController = TextEditingController(text: widget.contactNumber);
    aboutController = TextEditingController(text: widget.about);
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    placeController.dispose();
    ownerNameController.dispose();
    contactNumberController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  void saveChanges() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    String? token = await getIdToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication error'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/api/pets/${widget.petId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'name': nameController.text,
          'breed': breedController.text,
          'age': int.tryParse(ageController.text) ?? widget.age,
          'location': placeController.text,
          'imageUrl': widget.image,
          'ownerName': ownerNameController.text,
          'contactNumber': contactNumberController.text,
          'about': aboutController.text
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, {
          'name': nameController.text,
          'breed': breedController.text,
          'age': int.tryParse(ageController.text) ?? widget.age,
          'place': placeController.text,
          'image': widget.image,
          'ownerName': ownerNameController.text,
          'contactNumber': contactNumberController.text,
          'about': aboutController.text
        });
        widget.refreshPets();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update pet: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleBeige,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: const Text(
          'Edit Pet Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image container at the top
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.1),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.image.isNotEmpty
                      ? Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child:
                                Icon(Icons.pets, size: 100, color: Colors.grey),
                          ),
                        )
                      : const Center(
                          child:
                              Icon(Icons.pets, size: 100, color: Colors.grey),
                        ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Image upload feature coming soon!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Form fields in a card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pet Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: nameController,
                    label: 'Pet Name',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: breedController,
                    label: 'Breed',
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: ageController,
                    label: 'Age',
                    icon: Icons.cake,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: placeController,
                    label: 'Location',
                    icon: Icons.location_on,
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: aboutController,
                    label: 'About The Pet',
                    icon: Icons.question_mark,
                  ),
                  const SizedBox(height: 30),
                  // Contact information section
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: ownerNameController,
                    label: 'Owner Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: contactNumberController,
                    label: 'Contact Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _isSaving ? null : saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.brown.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.brown),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.brown, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
