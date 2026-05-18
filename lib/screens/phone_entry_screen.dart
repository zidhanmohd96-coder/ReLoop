import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme.dart';
import 'otp_verification_screen.dart';

class PhoneEntryScreen extends StatefulWidget {
  final String initialPhoneNumber;
  const PhoneEntryScreen({super.key, this.initialPhoneNumber = ''});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  late final TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate sending OTP code
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, a1, a2) => OtpVerificationScreen(
              phoneNumber: phone.startsWith('+') ? phone : '+91 $phone',
            ),
            transitionsBuilder: (context, a1, a2, child) =>
                FadeTransition(opacity: a1, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: AppTheme.getClayDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: 16,
                    ),
                    child: Icon(
                      LucideIcons.arrowLeft,
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      size: 20,
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),

                const SizedBox(height: 48),

                // Hero Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: AppTheme.getClayDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: 24,
                    ),
                    child: Icon(
                      LucideIcons.smartphone,
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      size: 36,
                    ),
                  ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms),
                ),

                const SizedBox(height: 40),

                // Headings
                Text(
                  'Enter Number',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                    letterSpacing: -1,
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                const SizedBox(height: 8),

                Text(
                  'We will send a 4-digit verification code to this mobile number.',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 40),

                // Mobile Number Input Field
                Container(
                  decoration: AppTheme.getClayDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: 24,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 12),
                        child: Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Enter 10-digit number',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            hintStyle: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 48),

                // Send OTP Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 8,
                      shadowColor: (isDark ? AppTheme.mintGreen : AppTheme.forestGreen).withOpacity(0.4),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: isDark ? const Color(0xFF0F172A) : Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Send Verification Code',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(curve: Curves.easeOutBack),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
