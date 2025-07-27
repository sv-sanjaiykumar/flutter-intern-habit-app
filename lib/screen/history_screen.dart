import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/history_provider.dart';
import 'history_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final historyList = historyProvider.history;

    const backgroundColor = Color(0xFF000000);
    const cardTextColor = Color(0xFFFFFFFF);
    const fadedTextColor = Color(0xFF656565);
    const appBarColor = Color(0xFF000000);
    const iconColor = Color(0xE400DC0E);
    const borderColor = Color(0xFF000000);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text(
          'Habit History',
          style: TextStyle(
            color: cardTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: cardTextColor),
        actions: [
          if (historyList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: iconColor),
              onPressed: () {
                historyProvider.clearHistory();
              },
              tooltip: 'Clear History',
            ),
        ],
      ),
      body: historyList.isEmpty
          ? const Center(
        child: Text(
          "No history yet.\nComplete habits to track them here.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fadedTextColor,
            fontSize: 16,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: historyList.length,
        itemBuilder: (ctx, index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF313244), // surface 1
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: HistoryTile(item: historyList[index]),
        ),
      ),
    );
  }
}
