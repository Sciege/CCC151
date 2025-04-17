// lib/services/pet_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class PetService {
  static const String apiUrl = 'http://localhost:5000/api/pets';  // Backend API URL

  Future<void> addPet(String token, Map<String, dynamic> petData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add token here
        },
        body: json.encode(petData),
      );

      if (response.statusCode == 201) {
        print("Pet added successfully!");
      } else {
        print("Failed to add pet. Status Code: ${response.statusCode}");
        throw Exception("Failed to add pet");
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }
}
