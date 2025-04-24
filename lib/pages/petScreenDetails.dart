import 'dart:convert';
import 'package:flutter/material.dart';
import '../authentication/auth_registered_users.dart';
import 'package:http/http.dart' as http;

class PetDetailsScreen extends StatefulWidget {
  final String name;
  final String breed;
  final int age;
  final String place;
  final String image;
  final bool isEditable;
  final String petId; // Unique identifier for the pet
  final VoidCallback refreshPets; // Callback to refresh the list of pets

  const PetDetailsScreen({
    super.key,
    required this.image,
    required this.name,
    required this.breed,
    required this.age,
    required this.place,
    this.isEditable = false, // Default value for isEditable
    required this.petId,
    required this.refreshPets,
  });

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  late String name;
  late String breed;
  late int age;
  late String place;
  late String image;

  @override
  void initState() {
    super.initState();
    // Initialize the state variables with the values passed from the widget
    name = widget.name;
    breed = widget.breed;
    age = widget.age;
    place = widget.place;
    image = widget.image;
  }

  // Method to update the pet details in the state
  void updatePetDetails(Map<String, dynamic> updatedDetails) {
    setState(() {
      name = updatedDetails['name'];
      breed = updatedDetails['breed'];
      age = updatedDetails['age'];
      place = updatedDetails['place'];
      image = updatedDetails['image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // Display the pet name in the app bar
        actions: widget.isEditable
            ? [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the EditPetScreen and wait for the result
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
                    refreshPets: widget.refreshPets,
                  ),
                ),
              );
              // If the EditPetScreen returns updated details, update the state
              if (updatedDetails != null) {
                updatePetDetails(updatedDetails);
              }
            },
          )
        ]
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: image.isNotEmpty
                      ? Image.network(image) // Display the pet image
                      : Icon(Icons.pets, size: 50), // Placeholder icon if no image
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Breed: $breed", style: TextStyle(fontSize: 18)),
            Text("Age: $age", style: TextStyle(fontSize: 18)),
            Text("Location: $place", style: TextStyle(fontSize: 18)),
          ],
        ),
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
  final String petId; // Unique identifier for the pet
  final VoidCallback refreshPets; // Callback to refresh the list of pets

  const EditPetScreen({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.place,
    required this.image,
    required this.petId,
    required this.refreshPets,
  });

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  late TextEditingController nameController;
  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController placeController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the values passed from the widget
    nameController = TextEditingController(text: widget.name);
    breedController = TextEditingController(text: widget.breed);
    ageController = TextEditingController(text: widget.age.toString());
    placeController = TextEditingController(text: widget.place);
  }

  @override
  void dispose() {
    // Dispose of the text controllers to free up resources
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    placeController.dispose();
    super.dispose();
  }

  // Method to save the changes made to the pet details
  void saveChanges() async {
    String? token = await getIdToken(); // Get the authentication token
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication error')),
      );
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
          'imageUrl': widget.image // Include the image URL
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet updated successfully')),
        );
        // Pop the screen and return the updated pet details
        Navigator.pop(context, {
          'name': nameController.text,
          'breed': breedController.text,
          'age': int.tryParse(ageController.text) ?? widget.age,
          'place': placeController.text,
          'image': widget.image,
        });
        widget.refreshPets(); // Call the refreshPets callback to update the list of pets
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update pet: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: widget.image.isNotEmpty
                    ? Image.network(widget.image, height: 200) // Display the pet image
                    : const Icon(Icons.pets, size: 100), // Placeholder icon if no image
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Pet Name'),
            ),
            TextField(
              controller: breedController,
              decoration: const InputDecoration(labelText: 'Breed'),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: placeController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
