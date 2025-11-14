// lib/screens/growth_mission_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class GrowthMissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Growth Missions", style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFE0D8FF), Color(0xFFF6E6FF)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Lottie.asset('assets/lottie/glow_pulse.json', height: 100),
                    Text(
                      "7-Day Truth Challenge",
                      style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Day 3: Share one verified fact with a friend.",
                      style: GoogleFonts.inter(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    LinearProgressIndicator(value: 3 / 7, backgroundColor: Colors.grey[300], color: Color(0xFF6C5CE7)),
                    SizedBox(height: 8),
                    Text("3 / 7 days", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}