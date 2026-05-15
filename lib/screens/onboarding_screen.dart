import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.forestGreen,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    LucideIcons.truck,
                    color: Colors.white,
                    size: 48,
                  ),
                ).animate()
                 .fadeIn(duration: 800.ms)
                 .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack)
                 .shimmer(delay: 1500.ms, duration: 2000.ms),
                const SizedBox(height: 24),
                Text(
                  'ReLoop',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                  ),
                ).animate()
                 .fadeIn(delay: 400.ms, duration: 800.ms)
                 .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 8),
                Text(
                  'PREMIUM RECYCLING',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightGreen,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate()
                 .fadeIn(delay: 600.ms, duration: 800.ms)
                 .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 48),
                Text(
                  'A real tech-enabled logistics company for a cleaner future. Paper and cardboard recycling, reimagined.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.forestGreen.withOpacity(0.7),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ).animate()
                 .fadeIn(delay: 800.ms, duration: 1000.ms),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const AuthScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.forestGreen,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'Join the Loop',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ).animate()
                 .fadeIn(delay: 1000.ms, duration: 800.ms)
                 .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'VERIFIED SUSTAINABILITY',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ).animate()
                 .fadeIn(delay: 1200.ms, duration: 800.ms),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


