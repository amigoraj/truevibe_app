// lib/screens/vibe_match_screen.dart
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VibeMatchScreen extends StatelessWidget {
  final List<Map<String, dynamic>> matches = [
    {
      'name': 'Alex',
      'distance': '1.2 km',
      'vibe': 'Deep Thinker',
      'passion': 'Coding',
      'compatibility': 92,
    },
    {
      'name': 'Luna',
      'distance': '2.8 km',
      'vibe': 'Calm Soul',
      'passion': 'Yoga',
      'compatibility': 87,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Vibe Match", style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16, 100, 16, 16),
          itemCount: matches.length,
          itemBuilder: (ctx, i) {
            final m = matches[i];
            return GlassmorphicContainer(
              width: double.infinity,
              height: 160,
              borderRadius: 20,
              blur: 20,
              alignment: Alignment.bottomCenter,
              border: 2,
              linearGradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderGradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.2)],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: Text(m['name'][0], style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(m['name'], style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text("${m['distance']} • ${m['vibe']}", style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label: Text(m['passion'], style: TextStyle(fontSize: 10)),
                                backgroundColor: Colors.white.withOpacity(0.3),
                              ),
                              SizedBox(width: 8),
                              Text("${m['compatibility']}% Match", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Connect"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF6C5CE7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (i * 200).ms).slideY(begin: 0.3);
          },
        ),
      ),
    );
  }
}