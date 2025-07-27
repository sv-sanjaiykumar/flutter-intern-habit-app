import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/habit_provider.dart';
import '../provider/history_provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');
    final dayFormatter = DateFormat('EEEE');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Checkbox(
          value: habit.isCompleted,
          activeColor: const Color(0xE400DC0E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (_) {
            Provider.of<HabitProvider>(context, listen: false).toggleHabit(
              habit.id,
              onCompleted: (habitName) {
                Provider.of<HistoryProvider>(context, listen: false).addToHistory(habitName);
              },
            );
          },
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          onPressed: () {
            Provider.of<HabitProvider>(context, listen: false).removeHabit(habit.id);
          },
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF2A2A2A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text(
                  habit.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '📝 Description:',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.description.isNotEmpty
                          ? habit.description
                          : 'No description provided.',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    if (habit.deadline != null)
                      Text(
                        '📅 Deadline: ${dayFormatter.format(habit.deadline!)} - ${dateFormatter.format(habit.deadline!)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '🕒 Created on: ${dayFormatter.format(habit.createdAt)} - ${dateFormatter.format(habit.createdAt)}',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close', style: TextStyle(color: Colors.greenAccent)),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
