// ✅ habit_provider.dart (UPDATED to use Habit model)

import 'package:flutter/material.dart';
import '../firebase/firebase_services.dart';
import '../model/habit.dart';

class HabitProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  Future<void> loadHabits() async {
    try {
      final data = await _firebaseService.fetchUserHabits();
      _habits = data.map<Habit>((habitMap) => Habit.fromMap(habitMap, habitMap['id'])).toList();
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

  Future<void> toggleHabit(String habitId, {Function(String habitName)? onCompleted}) async {
    try {
      final habit = _habits.firstWhere((h) => h.id == habitId);
      final currentStatus = habit.isCompleted;

      await _firebaseService.updateHabitStatus(habitId, !currentStatus);

      if (!currentStatus && onCompleted != null) {
        onCompleted(habit.title);
      }

      await loadHabits();
    } catch (e) {
      print("❌ Error updating habit status: $e");
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
