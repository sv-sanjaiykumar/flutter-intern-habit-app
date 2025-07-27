import 'package:flutter/material.dart';

class HistoryItem {
  final String habitName;
  final DateTime completedOn;

  HistoryItem({required this.habitName, required this.completedOn});
}

class HistoryProvider with ChangeNotifier {
  final List<HistoryItem> _history = [];

  List<HistoryItem> get history => _history.reversed.toList(); // Most recent first

  void addToHistory(String habitName) {
    _history.add(HistoryItem(
      habitName: habitName,
      completedOn: DateTime.now(),
    ));
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
