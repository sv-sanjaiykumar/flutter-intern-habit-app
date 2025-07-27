import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/timer_provider.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            timer.isRunning ? Icons.pause : Icons.play_arrow,
            color: Color(0xE400DC0E), // Custom primary color from theme.dart
          ),
          iconSize: 48,
          tooltip: timer.isRunning ? 'Pause' : 'Start',
          onPressed: () {
            timer.isRunning ? timer.pauseTimer() : timer.startTimer();
          },
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Icon(
            Icons.replay,
            color: Color(0xE400DC0E), // Custom error color from theme.dart
          ),
          iconSize: 48,
          tooltip: 'Reset',
          onPressed: timer.resetTimer,
        ),
      ],
    );
  }
}
