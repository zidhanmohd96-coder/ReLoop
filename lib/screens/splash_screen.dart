import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // Check if user is already authenticated
    bool isLoggedIn = false;
    try {
      if (Firebase.apps.isNotEmpty) {
        isLoggedIn = FirebaseAuth.instance.currentUser != null;
      }
    } catch (_) {}

    final Widget destination = isLoggedIn
        ? const HomeScreen()
        : const OnboardingScreen();
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkBgGradient : AppTheme.lightBgGradient,
        ),
        child: Stack(
          children: [
            // Background patterns or subtle 3D circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: (isDark ? AppTheme.mintGreen : AppTheme.leafGreen).withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(duration: 4.seconds, curve: Curves.easeInOut),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: (isDark ? AppTheme.mintGreen : AppTheme.forestGreen).withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(duration: 3.seconds, curve: Curves.easeInOut),
            ),
            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: AppTheme.getClayDecoration(
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      borderRadius: 40,
                    ),
                    child: Icon(
                      LucideIcons.truck,
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      size: 60,
                    ),
                  ).animate()
                   .fadeIn(duration: 800.ms)
                   .scale(curve: Curves.easeOutBack, duration: 800.ms)
                   .shimmer(delay: 1.seconds, duration: 2.seconds),
                  const SizedBox(height: 32),
                  Text(
                    'ReLoop',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                      letterSpacing: -1,
                    ),
                  ).animate()
                   .fadeIn(delay: 400.ms)
                   .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'RECYCLING REDEFINED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                      letterSpacing: 4,
                    ),
                  ).animate()
                   .fadeIn(delay: 600.ms)
                   .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
            
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppTheme.mintGreen : AppTheme.forestGreen),
                    ).animate().fadeIn(delay: 1.seconds),
                    const SizedBox(height: 16),
                    Text(
                      'STABILIZING LOGISTICS...',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 1.2.seconds),
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
