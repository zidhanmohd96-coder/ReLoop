import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme.dart';
import 'location_permission_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  void _toggleAuth() {
    setState(() {
      _isLogin = !_isLogin;
    });
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // 3D-ish Logo / Graphic
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: AppTheme.getClayDecoration(
                      color: Colors.white,
                      borderRadius: 24,
                    ),
                    child: const Icon(
                      LucideIcons.userPlus,
                      color: AppTheme.forestGreen,
                      size: 32,
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                ),
                const SizedBox(height: 48),
                Text(
                  _isLogin ? 'Welcome Back!' : 'Start ReLooping',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.forestGreen,
                    letterSpacing: -1,
                  ),
                ).animate(key: ValueKey('title_$_isLogin')).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: 8),
                Text(
                  _isLogin 
                    ? 'Log in to manage your pickups'
                    : 'Join our sustainability network today',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ).animate(key: ValueKey('subtitle_$_isLogin')).fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: 48),
                
                // Form Fields with Claymorphic Style
                if (!_isLogin) ...[
                  _buildClayTextField(
                    hint: 'Full Name',
                    icon: LucideIcons.user,
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                ],
                _buildClayTextField(
                  hint: 'Phone Number',
                  icon: LucideIcons.phone,
                  keyboardType: TextInputType.phone,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 16),
                _buildClayTextField(
                  hint: 'Password',
                  icon: LucideIcons.lock,
                  isPassword: true,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 12),
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppTheme.lightGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 32),
                
                // Primary Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, a1, a2) => const LocationPermissionScreen(),
                          transitionsBuilder: (context, a1, a2, child) => FadeTransition(opacity: a1, child: child),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.forestGreen,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 8,
                      shadowColor: AppTheme.forestGreen.withOpacity(0.4),
                    ),
                    child: Text(
                      _isLogin ? 'Login' : 'Create Account',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: 48),
                
                // Toggle Button
                Center(
                  child: GestureDetector(
                    onTap: _toggleAuth,
                    child: RichText(
                      text: TextSpan(
                        text: _isLogin ? "Don't have an account? " : "Already have an account? ",
                        style: TextStyle(color: Colors.grey.shade600),
                        children: [
                          TextSpan(
                            text: _isLogin ? "Register" : "Login",
                            style: const TextStyle(
                              color: AppTheme.forestGreen,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClayTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: AppTheme.getClayDecoration(
        color: Colors.white,
        borderRadius: 24,
      ),
      child: TextField(
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.leafGreen, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
