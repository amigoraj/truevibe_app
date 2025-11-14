import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Example OAuth URLs (replace with your backend endpoints)
  final String googleAuthUrl = "https://yourbackend.com/auth/google";
  final String facebookAuthUrl = "https://yourbackend.com/auth/facebook";

  Future<void> _handleOAuth(String url) async {
    try {
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: "truevibe", // e.g., truevibe://callback
      );
      // The result contains access token or code
      print("OAuth result: $result");
    } catch (e) {
      print("OAuth error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌊 Animated Sky Blue Waves
          AnimatedBackground(size: size),

          // 🩵 Login UI
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // App title
                  Text(
                    "TrueVibe",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue.shade700,
                      letterSpacing: 1.5,
                    ),
                  ).animate().fadeIn(duration: 1200.ms).slideY(begin: -0.3),

                  const SizedBox(height: 60),

                  // Email field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.lightBlue.shade300),
                        ),
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.blue[400]),
                      ),
                    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.lightBlue.shade300),
                        ),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[400]),
                      ),
                    ).animate().fadeIn(duration: 900.ms).slideX(begin: 0.2),
                  ),

                  const SizedBox(height: 40),

                  // Login button
                  GestureDetector(
                    onTap: () {
                      setState(() => isLoading = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => isLoading = false);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 55,
                      width: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [Colors.lightBlueAccent.shade100, Colors.blue.shade600],
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.blue.shade200, blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 1100.ms).slideY(begin: 0.3),

                  const SizedBox(height: 25),

                  // Social login buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        SocialLoginButton(
                          icon: Icons.g_mobiledata,
                          text: "Continue with Google",
                          color: Colors.redAccent.shade400,
                          onTap: () => _handleOAuth(googleAuthUrl),
                        ),
                        const SizedBox(height: 15),
                        SocialLoginButton(
                          icon: Icons.facebook,
                          text: "Continue with Facebook",
                          color: Colors.blue.shade800,
                          onTap: () => _handleOAuth(facebookAuthUrl),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 1200.ms),

                  const SizedBox(height: 20),

                  // Create new account button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Text(
                      "Create new account",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ).animate().fadeIn(duration: 1200.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🌊 Animated background
class AnimatedBackground extends StatefulWidget {
  final Size size;
  const AnimatedBackground({super.key, required this.size});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: widget.size,
          painter: _WavePainter(_controller.value),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double value;
  _WavePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.lightBlueAccent.withOpacity(0.6), Colors.blue.shade100.withOpacity(0.8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final yOffset = math.sin(value * 2 * math.pi) * 15;
    final yOffset2 = math.cos(value * 2 * math.pi) * 20;

    path.moveTo(0, size.height * 0.8 + yOffset);
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.8 +
            math.sin((i / size.width * 2 * math.pi) + value * 2 * math.pi) * 15 +
            yOffset2,
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => true;
}

// 🌟 Social login button widget
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
