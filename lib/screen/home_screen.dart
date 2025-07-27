import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/habit_provider.dart';
import 'habit_tile.dart';

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
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child!,
                                );
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
                        onPressed: () {
                          final title = habitController.text.trim();
                          final description = descriptionController.text.trim();
                          if (title.isNotEmpty) {
                            habitProvider.addHabit(
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
                itemBuilder: (ctx, index) =>
                    HabitTile(habit: habits[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
