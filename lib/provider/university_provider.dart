import 'package:flutter/material.dart';
import 'package:account/model/university_item.dart';
import 'package:account/database/university_db.dart';

class UniversityProvider with ChangeNotifier {
  List<UniversityItem> universities = [];

  final UniversityDB _db = UniversityDB(dbName: 'universities.db');

  // Load initial data
  Future<void> initData() async {
    universities = await _db.loadAllData();
    notifyListeners();
  }

  // Add a new university and update ranking based on score
  Future<void> addUniversity(UniversityItem university) async {
    int keyID = await _db.insertDatabase(university);
    university.keyID = keyID;
    universities.add(university);

    // Sort universities by score in descending order
    universities.sort((a, b) => b.score.compareTo(a.score));

    // Update rank based on the sorted list
    for (int i = 0; i < universities.length; i++) {
      universities[i].rank = i + 1; // Rank starts from 1
    }

    // Update the database with the new rankings
    for (var uni in universities) {
      await _db.updateData(uni);
    }

    notifyListeners();
  }

  // Update an existing university
  Future<void> updateUniversity(UniversityItem university) async {
    await _db.updateData(university);
    int index = universities.indexWhere((u) => u.keyID == university.keyID);
    universities[index] = university;
    notifyListeners();
  }

  // Delete a university
  Future<void> deleteUniversity(UniversityItem university) async {
    await _db.deleteData(university);
    universities.removeWhere((u) => u.keyID == university.keyID);
    notifyListeners();
  }

  // Method to update universities list (if needed)
  void updateUniversities(List<UniversityItem> updatedUniversities) {
    universities = updatedUniversities;
    notifyListeners(); // Notify listeners to update UI
  }
}
