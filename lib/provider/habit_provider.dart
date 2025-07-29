import 'package:flutter/material.dart';
import '../firebase/firebase_services.dart';

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
      await loadHabits();
    } catch (e) {
      print("Error adding habit: $e");
    }
  }

  Future<void> toggleHabit(String habitId, bool isCompleted) async {
    try {
      await _firebaseService.updateHabitStatus(habitId, isCompleted);
      await loadHabits();
    } catch (e) {
      print("Error updating habit status: $e");
    }
  }

  Future<void> removeHabit(String habitId) async {
    try {
      await _firebaseService.deleteHabit(habitId);
      await loadHabits();
    } catch (e) {
      print("Error deleting habit: $e");
    }
  }
}
