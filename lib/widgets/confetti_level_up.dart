// lib/widgets/confetti_level_up.dart
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ConfettiLevelUp extends StatefulWidget {
  final String newLevel;
  const ConfettiLevelUp({required this.newLevel, Key? key}) : super(key: key);

  @override
  _ConfettiLevelUpState createState() => _ConfettiLevelUpState();
}

class _ConfettiLevelUpState extends State<ConfettiLevelUp> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 3));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.05,
          numberOfParticles: 60,
          gravity: 0.3,
          colors: [
            Colors.amber,
            Colors.pink,
            Colors.purple,
            Colors.cyan,
            Colors.orange,
          ],
          shouldLoop: false,
        ),
        Padding(
          padding: EdgeInsets.only(top: 80),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43CBFF), Color(0xFFF107A3)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6))
              ],
            ),
            child: Text(
              "LEVEL UP! ${widget.newLevel}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}