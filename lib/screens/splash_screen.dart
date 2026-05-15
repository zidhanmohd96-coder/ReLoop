import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme.dart';
import 'onboarding_screen.dart';

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
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F7F4), Color(0xFFE4F0E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                  color: AppTheme.leafGreen.withOpacity(0.05),
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
                  color: AppTheme.forestGreen.withOpacity(0.05),
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
                      color: AppTheme.forestGreen,
                      borderRadius: 40,
                    ),
                    child: const Icon(
                      LucideIcons.truck,
                      color: Colors.white,
                      size: 60,
                    ),
                  ).animate()
                   .fadeIn(duration: 800.ms)
                   .scale(curve: Curves.easeOutBack, duration: 800.ms)
                   .shimmer(delay: 1.seconds, duration: 2.seconds),
                  const SizedBox(height: 32),
                  const Text(
                    'ReLoop',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.forestGreen,
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
                      color: AppTheme.lightGreen,
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
                    const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.forestGreen),
                    ).animate().fadeIn(delay: 1.seconds),
                    const SizedBox(height: 16),
                    Text(
                      'STABILIZING LOGISTICS...',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
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
