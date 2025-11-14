import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _selectedPassions = [];
  final List<String> _selectedMindsets = [];
  bool _locationEnabled = false;

  final List<Map<String, dynamic>> _passions = [
    {'icon': '🎨', 'label': 'Art & Design'},
    {'icon': '💼', 'label': 'Business'},
    {'icon': '🏋️', 'label': 'Fitness'},
    {'icon': '🎵', 'label': 'Music'},
    {'icon': '📚', 'label': 'Learning'},
    {'icon': '🍳', 'label': 'Cooking'},
    {'icon': '💻', 'label': 'Tech & Coding'},
    {'icon': '📸', 'label': 'Photography'},
    {'icon': '✈️', 'label': 'Travel'},
    {'icon': '✍️', 'label': 'Writing'},
  ];

  final List<Map<String, dynamic>> _mindsets = [
    {'icon': '🎯', 'label': 'Ambitious'},
    {'icon': '🎨', 'label': 'Creative'},
    {'icon': '🧘', 'label': 'Calm'},
    {'icon': '💪', 'label': 'Motivated'},
    {'icon': '🤝', 'label': 'Supportive'},
    {'icon': '🤔', 'label': 'Deep Thinker'},
    {'icon': '🌟', 'label': 'Positive'},
    {'icon': '🔬', 'label': 'Curious'},
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    // Save user data here (we'll connect to backend later)
    print('Passions: $_selectedPassions');
    print('Mindsets: $_selectedMindsets');
    print('Location: $_locationEnabled');
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7B68EE)),
          onPressed: () => _currentPage > 0 
              ? _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                )
              : Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(color: const Color(0xFF7B68EE)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 4,
                    decoration: BoxDecoration(
                      color: _currentPage >= index
                          ? const Color(0xFF7B68EE)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildPassionsPage(),
                _buildMindsetsPage(),
                _buildLocationPage(),
              ],
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _canContinue() ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B68EE),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _currentPage == 2 ? 'Get Started' : 'Continue',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    if (_currentPage == 0) return _selectedPassions.isNotEmpty;
    if (_currentPage == 1) return _selectedMindsets.isNotEmpty;
    return true;
  }

  Widget _buildPassionsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1/3',
            style: GoogleFonts.poppins(
              color: const Color(0xFF7B68EE),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'What are you passionate about?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose all that apply',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _passions.map((passion) {
              final isSelected = _selectedPassions.contains(passion['label']);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(passion['icon']),
                    const SizedBox(width: 8),
                    Text(passion['label']),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPassions.add(passion['label']);
                    } else {
                      _selectedPassions.remove(passion['label']);
                    }
                  });
                },
                selectedColor: const Color(0xFF7B68EE).withOpacity(0.2),
                checkmarkColor: const Color(0xFF7B68EE),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMindsetsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2/3',
            style: GoogleFonts.poppins(
              color: const Color(0xFF7B68EE),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'What describes you best?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose up to 3',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _mindsets.map((mindset) {
              final isSelected = _selectedMindsets.contains(mindset['label']);
              final canSelect = _selectedMindsets.length < 3 || isSelected;
              
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mindset['icon']),
                    const SizedBox(width: 8),
                    Text(mindset['label']),
                  ],
                ),
                selected: isSelected,
                onSelected: canSelect ? (selected) {
                  setState(() {
                    if (selected) {
                      _selectedMindsets.add(mindset['label']);
                    } else {
                      _selectedMindsets.remove(mindset['label']);
                    }
                  });
                } : null,
                selectedColor: const Color(0xFFFF6B6B).withOpacity(0.2),
                checkmarkColor: const Color(0xFFFF6B6B),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3/3',
            style: GoogleFonts.poppins(
              color: const Color(0xFF7B68EE),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Help us connect you with people nearby!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 48,
                  color: Color(0xFF7B68EE),
                ),
                const SizedBox(height: 16),
                Text(
                  'Why we need this:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBenefit('Find gym buddies near you'),
                _buildBenefit('Discover local businesses'),
                _buildBenefit('Meet people in your area'),
                const SizedBox(height: 24),
                Text(
                  'Your privacy matters:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPrivacy('We never share exact address'),
                _buildPrivacy('You control who sees it'),
                _buildPrivacy('Can disable anytime'),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() => _locationEnabled = true);
              },
              icon: const Icon(Icons.location_on),
              label: Text(_locationEnabled ? 'Location Enabled ✓' : 'Enable Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _locationEnabled 
                    ? Colors.green 
                    : const Color(0xFF7B68EE),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacy(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Color(0xFF7B68EE), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}