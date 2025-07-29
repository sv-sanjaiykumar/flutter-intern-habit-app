import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/timer_provider.dart';
import 'timer_controls.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Focus Timer'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E0E0E), // Direct use of green color
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(timer.seconds),
              style: textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Matching textTheme color
              ),
            ),
            const SizedBox(height: 40),
            const TimerControls(),
          ],
        ),
      ),
    );
  }
}
