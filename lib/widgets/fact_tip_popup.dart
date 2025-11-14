// lib/widgets/fact_tip_popup.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FactTipPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFF8F4FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lightbulb, color: Colors.amber, size: 40),
          SizedBox(height: 16),
          Text(
            "Fact-Check Tip",
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 12),
          Text(
            "• Does this have a verified source?\n"
            "• Is the image/video edited?\n"
            "• Check date & context\n"
            "Stay neutral until sure!",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Got it!"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}