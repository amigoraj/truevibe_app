// lib/widgets/reaction_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';

class ReactionButton extends StatefulWidget {
  final String postId;
  final String type; // inspired, neutral, etc.
  final IconData icon;
  final Color color;
  final String label;

  const ReactionButton({
    Key? key,
    required this.postId,
    required this.type,
    required this.icon,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isReacted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: 600.ms);
  }

  Future<void> _react() async {
    if (_isReacted) return;

    setState(() => _isReacted = true);
    _pulseController.forward();

    try {
      final response = await ApiService.post('/reactions', {
        'postId': widget.postId,
        'reactionType': widget.type,
      });

      final data = response.data;
      if (data['showFactTip'] == true) {
        _showFactTip(context);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("+${_getPoints()} Vibe Points!"),
            backgroundColor: widget.color,
            duration: 1.5.seconds,
          ),
        );
      }
    } catch (e) {
      setState(() => _isReacted = false);
    }
  }

  int _getPoints() {
    const points = {
      'inspired': 2,
      'neutral': 1,
      'questioning': 2,
      'supportive': 3,
      'unclear': 0,
    };
    return points[widget.type] ?? 0;
  }

  void _showFactTip(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => FactTipPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _react,
      child: Animate(
        controller: _pulseController,
        effects: [
          ScaleEffect(begin: 1, end: 1.3, duration: 300.ms),
          ScaleEffect(begin: 1.3, end: 1, delay: 300.ms, duration: 300.ms),
        ],
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.color.withOpacity(0.3), widget.color.withOpacity(0.1)],
                ),
                shape: BoxShape.circle,
                boxShadow: _isReacted
                    ? [BoxShadow(color: widget.color.withOpacity(0.5), blurRadius: 20)]
                    : [],
              ),
              child: Icon(widget.icon, color: widget.color, size: 28),
            ),
            SizedBox(height: 4),
            Text(widget.label, style: TextStyle(fontSize: 10, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}