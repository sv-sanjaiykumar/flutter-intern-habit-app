import 'package:cloud_firestore/cloud_firestore.dart';

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

  // If you're working with Firestore, you'll want fromMap and toMap methods:

  factory Habit.fromMap(Map<String, dynamic> data, String docId) {
    return Habit(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deadline: data['deadline'] != null ? (data['deadline'] as Timestamp).toDate() : null,
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'deadline': deadline,
      'isCompleted': isCompleted,
    };
  }
}
