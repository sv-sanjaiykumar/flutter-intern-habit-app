import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/habit_provider.dart';
import '../provider/history_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController habitController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDeadline;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HabitProvider>(context, listen: false).loadHabits();
    });
  }

  @override
  void dispose() {
    habitController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final habits = habitProvider.habits;

    const backgroundColor = Color(0xFF0E0E0E);
    const cardColor = Color(0xFF1A1A1A);
    const hintColor = Colors.grey;
    const titleColor = Colors.white;
    const subtitleColor = Colors.white70;
    const iconColor = Color(0xE400DC0E);
    const textFieldTextColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        title: const Text(
          "Today's Habits",
          style: TextStyle(
            color: titleColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: habitController,
                      style: const TextStyle(
                        color: textFieldTextColor,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter habit title',
                        hintStyle: TextStyle(
                          color: hintColor,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(
                        color: textFieldTextColor,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                        hintStyle: TextStyle(
                          color: hintColor,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDeadline == null
                                ? "No deadline selected"
                                : "Deadline: ${DateFormat.yMMMd().format(selectedDeadline!)}",
                            style: const TextStyle(color: subtitleColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(data: ThemeData.dark(), child: child!);
                              },
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDeadline = pickedDate;
                              });
                            }
                          },
                          child: const Text("Pick Deadline"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: iconColor,
                          size: 32,
                        ),
                        onPressed: () async {
                          final title = habitController.text.trim();
                          final description = descriptionController.text.trim();
                          if (title.isNotEmpty) {
                            await habitProvider.addHabit(
                              title,
                              description,
                              selectedDeadline,
                            );
                            habitController.clear();
                            descriptionController.clear();
                            setState(() {
                              selectedDeadline = null;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              habits.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "No habits yet.\nStart by adding one!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
                  : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: habits.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, index) => HabitTile(habit: habits[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HabitTile extends StatelessWidget {
  final Map<String, dynamic> habit;

  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');
    final dayFormatter = DateFormat('EEEE');

    final String id = habit['id'];
    final String title = habit['title'] ?? '';
    final String description = habit['description'] ?? '';
    final bool isCompleted = habit['isCompleted'] ?? false;

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
          value: isCompleted,
          activeColor: const Color(0xE400DC0E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (_) {
            Provider.of<HabitProvider>(context, listen: false)
                .toggleHabit(id, !isCompleted);
          },
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          onPressed: () {
            Provider.of<HabitProvider>(context, listen: false).removeHabit(id);
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
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      '📝 Description:',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description.isNotEmpty ? description : 'No description provided.',
                      style: const TextStyle(color: Colors.white70),
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
