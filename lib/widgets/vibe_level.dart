// Add to profile or app bar
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)]),
    borderRadius: BorderRadius.circular(30),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(user.vibeLevel, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      SizedBox(width: 8),
      Text("${user.vibeScore} pts", style: TextStyle(color: Colors.white70)),
    ],
  ),
)