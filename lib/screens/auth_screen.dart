import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/app_state.dart';
import 'location/location_permission_screen.dart';
import 'phone_entry_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuth() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a1, a2) => const LocationPermissionScreen(),
        transitionsBuilder: (context, a1, a2, child) =>
            FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  Future<void> _handleAuth() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final name = _nameController.text.trim();
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    // Validation
    if (!_isLogin && name.isEmpty) {
      _showError('Please enter your full name');
      return;
    }

    if (identifier.isEmpty) {
      _showError('Please enter your phone number or email');
      return;
    }

    final isEmail = identifier.contains('@');
    if (isEmail) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(identifier)) {
        _showError('Please enter a valid email address');
        return;
      }
    } else {
      final cleanPhone = identifier.replaceAll(RegExp(r'\D'), '');
      if (cleanPhone.length != 10) {
        _showError('Please enter a valid 10-digit mobile number');
        return;
      }
    }

    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (appState.isFirebaseEnabled) {
        if (_isLogin) {
          await appState.signInWithIdentifierAndPassword(identifier, password);
        } else {
          await appState.signUpWithIdentifierAndPassword(name, identifier, password);
        }
      }
      
      if (mounted) {
        _navigateToHome();
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkBgGradient : AppTheme.lightBgGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Logo
                    Center(
                      child:
                          Container(
                            width: 80,
                            height: 80,
                            decoration: AppTheme.getClayDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              borderRadius: 24,
                            ),
                            child: Icon(
                              _isLogin
                                  ? LucideIcons.logIn
                                  : LucideIcons.userPlus,
                              color: isDark
                                  ? AppTheme.mintGreen
                                  : AppTheme.forestGreen,
                              size: 32,
                            ),
                          ).animate().scale(
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          ),
                    ),
                    const SizedBox(height: 40),
                    // Title
                    Text(
                          _isLogin ? 'Welcome Back!' : 'Start ReLooping',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : AppTheme.forestGreen,
                            letterSpacing: -1,
                          ),
                        )
                        .animate(key: ValueKey('title_$_isLogin'))
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 8),
                    Text(
                          _isLogin
                              ? 'Log in to manage your pickups'
                              : 'Join our sustainability network today',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        )
                        .animate(key: ValueKey('subtitle_$_isLogin'))
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 40),

                    // Form Fields
                    if (!_isLogin) ...[
                      _buildClayTextField(
                            hint: 'Full Name',
                            icon: LucideIcons.user,
                            isDark: isDark,
                            controller: _nameController,
                          )
                          .animate()
                          .fadeIn(delay: 100.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                    ],
                    _buildClayTextField(
                          hint: 'Phone Number or Email',
                          icon: LucideIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                          isDark: isDark,
                          controller: _identifierController,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 16),
                    _buildClayTextField(
                          hint: 'Password',
                          icon: LucideIcons.lock,
                          isPassword: true,
                          isDark: isDark,
                          controller: _passwordController,
                        )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.1, end: 0),

                    if (_isLogin) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Coming Soon!!!')),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.mintGreen
                                  : AppTheme.lightGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Primary Action Button
                    SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppTheme.mintGreen
                                  : AppTheme.forestGreen,
                              foregroundColor: isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 8,
                              shadowColor:
                                  (isDark
                                          ? AppTheme.mintGreen
                                          : AppTheme.forestGreen)
                                      .withOpacity(0.4),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isLogin ? 'Login' : 'Create Account',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )

                        .animate()
                        .fadeIn(delay: 400.ms)
                        .scale(curve: Curves.easeOutBack),

                    const SizedBox(height: 24),

                    // // Divider with "OR"
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         height: 1,
                    //         color: isDark
                    //             ? Colors.grey.shade800
                    //             : Colors.grey.shade300,
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 16),
                    //       child: Text(
                    //         'OR',
                    //         style: TextStyle(
                    //           color: isDark
                    //               ? Colors.grey.shade600
                    //               : Colors.grey.shade500,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 12,
                    //           letterSpacing: 1,
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Container(
                    //         height: 1,
                    //         color: isDark
                    //             ? Colors.grey.shade800
                    //             : Colors.grey.shade300,
                    //       ),
                    //     ),
                    //   ],
                    // ).animate().fadeIn(delay: 500.ms),

                    // const SizedBox(height: 24),

                    // // Social/Alt buttons
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: OutlinedButton.icon(
                    //     onPressed: _navigateToOtp,
                    //     icon: const Icon(LucideIcons.smartphone, size: 18),
                    //     label: const Text(
                    //       'Continue with OTP',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //     style: OutlinedButton.styleFrom(
                    //       foregroundColor: isDark
                    //           ? AppTheme.mintGreen
                    //           : AppTheme.forestGreen,
                    //       side: BorderSide(
                    //         color: isDark
                    //             ? Colors.grey.shade800
                    //             : Colors.grey.shade300,
                    //         width: 1.5,
                    //       ),
                    //       padding: const EdgeInsets.symmetric(vertical: 18),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(24),
                    //       ),
                    //     ),
                    //   ),
                    // ).animate().fadeIn(delay: 550.ms),

                    const SizedBox(height: 32),

                    // Toggle
                    Center(
                      child: GestureDetector(
                        onTap: _toggleAuth,
                        child: RichText(
                          text: TextSpan(
                            text: _isLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: _isLogin ? "Register" : "Login",
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.mintGreen
                                      : AppTheme.forestGreen,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 32),

                    // Trust badges
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTrustBadge(
                            LucideIcons.shield,
                            'Secure',
                            isDark,
                          ),
                          const SizedBox(width: 24),
                          _buildTrustBadge(
                            LucideIcons.lock,
                            'Encrypted',
                            isDark,
                          ),
                          const SizedBox(width: 24),
                          _buildTrustBadge(LucideIcons.leaf, 'Green', isDark),
                        ],
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isDark ? AppTheme.mintGreen : AppTheme.leafGreen)
                .withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildClayTextField({
    required String hint,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 24,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: isDark ? AppTheme.mintGreen : AppTheme.leafGreen,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          hintStyle: TextStyle(
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
