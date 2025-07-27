import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? deadline;
  bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.deadline,
    this.isCompleted = false,
  });
}

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(String title, String description, DateTime? deadline) {
    _habits.add(
      Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        deadline: deadline,
      ),
    );
    notifyListeners();
  }

  void toggleHabit(String id, {Function(String)? onCompleted}) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.isCompleted = !habit.isCompleted;
    notifyListeners();

    if (habit.isCompleted && onCompleted != null) {
      onCompleted(habit.title); // Add habit name to history
    }
  }


  void removeHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }
}
