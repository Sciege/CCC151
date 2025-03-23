import 'package:fureverhome/tests/test_data.dart';

List<Map<String, dynamic>> filterPets({required String query}) {
  if(query == null || query.isEmpty)return displayPets;

  List searchQuery = query.toLowerCase().split(' ');
  return displayPets.where((pet) {
    String petData = '${pet['name']}  ${pet['breed']} ${pet['place']} ${pet['age']}'.toLowerCase();
    return searchQuery.every((item) => petData.contains(item));
  }).toList();
}

