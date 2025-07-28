import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class HabitProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _habits = [];

  List<Map<String, dynamic>> get habits => _habits;

  Future<void> loadHabits() async {
    try {
      _habits = await _firebaseService.fetchUserHabits();
      notifyListeners();
    } catch (e) {
      print("Error loading habits: $e");
    }
  }

  Future<void> addHabit(String title, String description, [DateTime? deadline]) async {
    try {
      await _firebaseService.addHabit(title, description, deadline);
      await loadHabits(); // Reload to update UI
    } catch (e) {
      print("Error adding habit: $e");
    }
  }
}
