// Add to top of feed_screen.dart
enum FeedType { fun, passion }

class _FeedScreenState extends State<FeedScreen> {
  FeedType _currentFeed = FeedType.fun;

  Widget _buildToggle() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTab("Fun", FeedType.fun, Icons.celebration),
          _buildTab("Passion", FeedType.passion, Icons.auto_awesome),
        ],
      ),
    );
  }

  Widget _buildTab(String label, FeedType type, IconData icon) {
    final isActive = _currentFeed == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentFeed = type),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? Color(0xFF6C5CE7) : Colors.white),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Color(0xFF6C5CE7) : Colors.white,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}