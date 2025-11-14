import 'package:flutter/material.dart';

class ThinkFirstDialog extends StatefulWidget {
  final String postContent;
  final VoidCallback onProceed;
  
  const ThinkFirstDialog({
    Key? key,
    required this.postContent,
    required this.onProceed,
  }) : super(key: key);

  @override
  State<ThinkFirstDialog> createState() => _ThinkFirstDialogState();
}

class _ThinkFirstDialogState extends State<ThinkFirstDialog> {
  bool _watchedFull = false;
  bool _checkedSource = false;
  bool _thoughtAboutIt = false;
  
  bool get _canProceed => _watchedFull && _checkedSource && _thoughtAboutIt;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Think First! 🤔',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Earn +10 Wisdom Points by thinking before reacting',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            _buildCheckItem(
              'Did you watch/read the full content?',
              _watchedFull,
              (value) => setState(() => _watchedFull = value!),
            ),
            const SizedBox(height: 12),
            _buildCheckItem(
              'Did you check the source?',
              _checkedSource,
              (value) => setState(() => _checkedSource = value!),
            ),
            const SizedBox(height: 12),
            _buildCheckItem(
              'Did you think about it critically?',
              _thoughtAboutIt,
              (value) => setState(() => _thoughtAboutIt = value!),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No problem! Take your time to think 💭'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed ? () {
                      Navigator.pop(context);
                      widget.onProceed();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              SizedBox(width: 8),
                              Text('+10 Wisdom Points! Great thinking! 🧠'),
                            ],
                          ),
                          backgroundColor: Color(0xFF8B5CF6),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Proceed'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Show educational content
                _showFactCheckTips(context);
              },
              icon: const Icon(Icons.info_outline, size: 18),
              label: const Text('Learn about fact-checking'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text, bool value, Function(bool?) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value ? const Color(0xFF8B5CF6).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF8B5CF6) : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF8B5CF6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (value)
            const Icon(
              Icons.check_circle,
              color: Color(0xFF8B5CF6),
              size: 20,
            ),
        ],
      ),
    );
  }

  void _showFactCheckTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.school, color: Color(0xFF8B5CF6)),
            SizedBox(width: 12),
            Text('Fact-Checking Tips'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Check the Source',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Is it from a reliable, verified account?'),
              SizedBox(height: 12),
              Text(
                '2. Look for Evidence',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Are there photos, videos, or documents?'),
              SizedBox(height: 12),
              Text(
                '3. Search Online',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('What do other sources say about this?'),
              SizedBox(height: 12),
              Text(
                '4. Check the Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Is this old news being shared as new?'),
              SizedBox(height: 12),
              Text(
                '5. Think About Motive',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Why would someone share false information?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}