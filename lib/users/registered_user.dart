import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fureverhome/authentication/auth_registered_users.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../colors/appColors.dart';
import '../pages/info.dart';
import '../pages/petScreenDetails.dart';

class RegisteredUser extends StatefulWidget {
  const RegisteredUser({super.key});

  static final registered_user_screen = '/registered_user';

  @override
  State<RegisteredUser> createState() => _RegisteredUserState();
}

class _RegisteredUserState extends State<RegisteredUser> {
  List pets = []; // List to store pets
  File? _image; // Variable to store the selected image
  // Controllers for text fields
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final placeController = TextEditingController();
  final ownerNameController = TextEditingController();
  final aboutController = TextEditingController();
  final numberController = TextEditingController();

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Fetch pets data from backend
  //GET
  Future getPets() async {
    String? token = await getIdToken();
    //print(token);
    print("Token first 10 chars: ${token?.substring(0, 10)}...");
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:5000/api/pets/registered'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Correctly passing the token
      });

      if (response.statusCode == 200) {
        setState(() {
          pets = json.decode(response.body); // Update pets list
        });
      } else {
        print('Failed to load pets');
      }
    } catch (e) {
      print('Error fetching pets: $e');
    }
  }

  // Update pet details
  //PUT
  Future putPet(String petId) async {
    String? token = await getIdToken();
    try {
      final response = await http.put(
          Uri.parse('http://10.0.2.2:5000/api/pets/$petId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'name': nameController.text,
            'breed': breedController.text,
            'age': ageController.text,
            'location': placeController.text
          }));
      if (response.statusCode == 200) {
        print('Updated pet successfully');
        getPets();
      } else {
        print('Failed to update the pets');
      }
    } catch (e) {
      print(e);
    }
  }

  // Add new pet to backend
  //POST
  Future addPet() async {
    String? token = await getIdToken();

    try {
      String? imageUrl;

      // Step 1: Upload image first (if selected)
      if (_image != null) {
        var uploadRequest = http.MultipartRequest(
          'POST',
          Uri.parse('http://10.0.2.2:5000/api/pets/upload'),
        );

        uploadRequest.headers['Authorization'] = 'Bearer $token';

        uploadRequest.files.add(await http.MultipartFile.fromPath(
          'image', // must match backend field
          _image!.path,
        ));

        var uploadResponse = await uploadRequest.send();

        if (uploadResponse.statusCode == 200) {
          final responseBody = await uploadResponse.stream.bytesToString();
          print('Response Body $responseBody');
          final decoded = json.decode(responseBody);
          print('Decoded Response: $decoded');
          imageUrl = decoded['imageUrl']; // get the image URL from backend
          print('Image Url $imageUrl');
        } else {
          print('Image upload failed: ${uploadResponse.statusCode}');
          return;
        }
      }

      // Step 2: Add the pet info (JSON body)

      final petResponse = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/pets'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // <-- replace or manage via auth
        },
        body: json.encode({
          'name': nameController.text,
          'breed': breedController.text,
          'age': ageController.text,
          'location': placeController.text,
          'imageUrl': imageUrl ?? '', // pass image URL
          'about': aboutController.text,
          'ownerName': ownerNameController.text,
          'contactNumber': numberController.text
        }),
      );

      if (petResponse.statusCode == 201) {
        print('Pet added successfully');
        //NEW
        await getPets();
        // Update the pets list manually to include the newly added pet
        // setState(() {
        //   pets.add({
        //     'name': nameController.text,
        //     'breed': breedController.text,
        //     'age': ageController.text,
        //     'location': placeController.text,
        //     'imageUrl': imageUrl ?? '', // if no image, an empty string
        //     'about': aboutController.text,
        //     'ownerName': ownerNameController.text,
        //     'contactNumber': numberController.text
        //   });
        // });
        print({
          'name': nameController.text,
          'breed': breedController.text,
          'age': int.tryParse(ageController.text) ?? 0,
          'place': placeController.text,
          'about': aboutController.text,
          'imageUrl': imageUrl ?? '',
          'ownerName': ownerNameController.text,
          'contact': numberController.text,
        });
      } else {
        print('Failed to add pet: ${petResponse.statusCode}');
        print(petResponse.body);
      }
    } catch (e) {
      print('Error adding pet: $e');
    }
  }

  // Delete list pet
  //DELETE
  Future deletePet(String petId) async {
    String? token = await getIdToken();
    if (token == null) {
      print('No deletion happened');
      return false;
    }
    try {
      final response = await http
          .delete(Uri.parse('http://10.0.2.2:5000/api/pets/$petId'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print("Delete response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Pet deleted successfully");
        //NEW
        await getPets();
        return true;
      } else {
        print('Failed to delete pet: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting pet: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getPets(); // Fetch the pets when the screen is initialized
  }

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source, StateSetter setModalState) async {
    /// setModalState is needed since we just want
    /// to restart the alertDialog note this only wokrs inside statefull builder
    ///
    /// the setState is for the main body
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setModalState(() {
        _image = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.darkBlueGray,
        foregroundColor: AppColors.mediumBlueGray,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                /// Wrap to Stateful Builder to use StateSetter
                builder: (BuildContext context, setState) {
                  return AlertDialog(
                    backgroundColor: AppColors.paleBeige,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Text(
                      'List Your Pet for Adoption',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown, // Matching the color scheme
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          imageProfile(setState),
                          // Assuming this is the profile image widget
                          SizedBox(height: 16),
                          _buildTextField(
                            controller: nameController,
                            label: 'Pet Name',
                            icon: Icons.pets,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: breedController,
                            label: 'Breed',
                            icon: Icons.category,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: ageController,
                            label: 'Age (yrs)',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: placeController,
                            label: 'Location',
                            icon: Icons.location_on,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: aboutController,
                            label: 'About the Pet',
                            icon: Icons.question_mark,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: ownerNameController,
                            label: 'Owner Name',
                            icon: Icons.person,
                          ),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: numberController,
                            label: 'Contact Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    actionsPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          // Reset the selected image to null if pressed cancel
                          setState(() {
                            _image = null;
                          });
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: Colors.brown),
                        ),
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.brown)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty ||
                              breedController.text.trim().isEmpty ||
                              ageController.text.trim().isEmpty ||
                              ageController.text.trim().isEmpty ||
                              placeController.text.trim().isEmpty ||
                              aboutController.text.trim().isEmpty ||
                              ownerNameController.text.trim().isEmpty ||
                              numberController.text.trim().isEmpty) {
                            // You can show a SnackBar or Dialog to notify the user
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: AppColors.errorRed,
                                  content: Text('Please fill out all fields.')),
                            );
                            return; // Prevent further execution
                          }

                          await addPet();
                          Navigator.of(context).pop();
                          nameController.clear();
                          breedController.clear();
                          ageController.clear();
                          placeController.clear();
                          aboutController.clear();
                          ownerNameController.clear();
                          numberController.clear();
                          setState(() {
                            _image = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[100],
                          // Matching the button color
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Add Pet',
                          style: TextStyle(color: Colors.brown),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        icon: Icon(Icons.add),
        label: Text('List a New Pet'),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Pet Listings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                fontSize: 18,
              ),
            ),
            Text(
              'Manage pets you\'ve listed for adoption',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Info.info_screen);
            },
            icon: Icon(
              Icons.info_outline,
              size: 28,
            ),
          ),
        ],
      ),
      body: Container(
        color: AppColors.paleBeige,
        child: Padding(
            padding: EdgeInsets.all(25),
            child: pets.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // 2 items per row
                      crossAxisSpacing: 8, // Space between columns
                      mainAxisSpacing: 25, // Space between rows
                      childAspectRatio: 0.8, // Adjust size ratio of each item
                    ),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return Dismissible(
                        // Use the MongoDB _id which should be included in the response
                        key: Key(pet['_id'] ?? index.toString()),
                        direction: DismissDirection.endToStart,
                        // Optional: Add background color or confirmation when swiping
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home, color: Colors.white),
                              Text(
                                'ADOPTED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add handling for when user swipes to dismiss
                        confirmDismiss: (direction) async {
                          //pops up
                          return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.creamWhite,
                                  title: Text("Confirm Adoption"),
                                  content: Text(
                                      "Has ${pet['name']} been adopted? This will remove the listing."),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text("Yes, Adopted!"),
                                    ),
                                  ],
                                );
                              });
                        },
                        onDismissed: (direction) async {
                          // You could implement a deletePet function here
                          // deletePet(pet['_id']);

                          // Update the UI by removing the pet from the list
                          setState(() {
                            pets.removeAt(index);
                          });
                          bool success = await deletePet(pet['_id']);

                          if (!success) {
                            print('failed to delete the pet');
                            getPets();
                          }
                        },
                        child: _petCard(
                            image: pet['imageUrl'],
                            name: pet['name'],
                            breed: pet['breed'],
                            age: pet['age'],
                            place: pet['location'],
                            pet: pet,
                            about: pet['about'],
                            contactNumber: pet['contactNumber'],
                            ownerName: pet['ownerName'],
                            context: context,
                            putPet: putPet,
                            // ✅ Added
                            refreshPets: getPets // ✅ Added),
                            ),
                      );
                      //   ListTile(
                      //   title: Text(pet['name']),
                      //   subtitle: Text(
                      //       '${pet['breed']} | Age: ${pet['age']} | Location: ${pet['location']}'),
                      // );
                    },
                  )),
      ),
    );
  }

  // The fixed imageProfile widget
  Widget imageProfile(StateSetter setModalState) {
    return Stack(
      children: <Widget>[
        Center(
          child: _image == null
              ? Container(
                  height: 150,
                  width: 150, // Optionally add width for consistency
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Optional background color
                    borderRadius:
                        BorderRadius.circular(12), // Optional rounded corners
                  ),
                  child: Icon(
                    Icons.pets,
                    size: 50, // Adjust the size of the icon
                    color: Colors.grey, // Icon color
                  ),
                )
              : Image.file(
                  _image!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => bottomSheet(setModalState),
              );
            },
            child: Icon(Icons.camera_alt_outlined),
          ),
        ),
      ],
    );
  }

// Bottom sheet for choosing photo source
  Widget bottomSheet(StateSetter setModalState) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text('Choose Photo'),
          SizedBox(height: 20),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  _pickImage(
                      ImageSource.camera, setModalState); // Pick from camera
                },
                label: Text('Camera'),
                icon: Icon(Icons.camera_alt),
              ),
              TextButton.icon(
                onPressed: () {
                  _pickImage(
                      ImageSource.gallery, setModalState); // Pick from gallery
                },
                label: Text('Gallery'),
                icon: Icon(Icons.image),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    placeController.dispose();
    aboutController.dispose();
    ownerNameController.dispose();
    numberController.dispose();
    super.dispose();
  }
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
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.brown, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

Widget _petCard(
    {required dynamic image,
    required String name,
    required String breed,
    required dynamic age,
    required String place,
    required BuildContext context,
    required Map<String, dynamic> pet, // <-- Added to access pet fields
    required Future<void> Function(String) putPet,
    required VoidCallback
        refreshPets, // <-- Added to re-fetch pets after update
    required String about,
    required String ownerName,
    required String contactNumber}) {
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
            age: age,
            place: place,
            contactNumber: contactNumber,
            about: about,
            ownerName: ownerName,
            isEditable: true,
            petId: pet['_id'],
            // Pass the pet ID from the pet object
            refreshPets: refreshPets, // Pass the refreshPets callback
          ),
        ),
      ).then((value) {
        // Refresh pets list when returning from details screen
        if (value != null) {
          refreshPets();
        }
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
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
          // Image container with fixed aspect ratio
          AspectRatio(
            aspectRatio: 1.5,
            // Width is 1.5 times the height (landscape format)
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover, // Crop to fill the container
                      alignment: Alignment.center, // Focus on center of image
                      errorBuilder: (context, error, stackTrace) {
                        print("Image error for $imageUrl: $error");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                Text(breed),
                Text("Age: $petAge"),
                Text(place),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
