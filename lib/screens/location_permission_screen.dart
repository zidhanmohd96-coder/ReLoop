import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import 'home_screen.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isLoading = false;
  bool _locationFetched = false;

  void _fetchLocation() {
    setState(() {
      _isLoading = true;
    });

    // Simulate location fetching delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _locationFetched = true;
      });
    });
  }

  void _continueToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
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
        child: SafeArea(
          child: Column(
            children: [
              // Top Map Section
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: double.infinity,
                    decoration: AppTheme.getClayDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: 32,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Dummy Map Background
                        Positioned.fill(
                          child: Opacity(
                            opacity: isDark ? 0.3 : 0.5,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Overlay Gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.1),
                                  (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        // Center Pin
                        if (_locationFetched)
                          Center(
                            child:
                                Icon(
                                  LucideIcons.mapPin,
                                  size: 48,
                                  color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                                ).animate().scale(
                                  curve: Curves.elasticOut,
                                  duration: 800.ms,
                                ),
                          )
                        else if (_isLoading)
                          Center(
                            child: CircularProgressIndicator(
                              color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                            ),
                          )
                        else
                          Center(
                            child:
                                const Icon(
                                      LucideIcons.map,
                                      size: 48,
                                      color: Colors.grey,
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true),
                                    )
                                    .shimmer(duration: 2000.ms),
                          ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),
                ),
              ),

              // Bottom Content Section
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    border: isDark ? Border.all(color: Colors.white.withOpacity(0.08), width: 1) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        _locationFetched
                            ? 'Location Found!'
                            : 'Enable Location',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.forestGreen,
                        ),
                      ).animate(target: _locationFetched ? 1 : 0).fadeIn(),
                      const SizedBox(height: 16),
                      Text(
                        _locationFetched
                            ? 'We have successfully fetched your exact location. You are ready to schedule your first pickup!'
                            : 'To provide you with accurate scrap prices and connect you with nearby pickup staff, we need your location.',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Address Details (Only when fetched)
                      if (_locationFetched)
                        Container(
                              padding: const EdgeInsets.all(24),
                              decoration: AppTheme.getClayDecoration(
                                color: isDark ? const Color(0xFF0F172A) : AppTheme.softBeige,
                                borderRadius: 24,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: (isDark ? AppTheme.mintGreen : AppTheme.leafGreen).withOpacity(
                                        0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      LucideIcons.navigation,
                                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Current Address',
                                          style: TextStyle(
                                            color: isDark ? Colors.grey.shade500 : Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '123 Green Valley Road, Eco Park, City Center',
                                          style: TextStyle(
                                            color: isDark ? Colors.white : AppTheme.forestGreen,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.1, end: 0),

                      const Spacer(),

                      // Action Buttons
                      if (!_locationFetched)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _fetchLocation,
                            icon: const Icon(LucideIcons.mapPin, size: 20),
                            label: const Text(
                              'Use Current Location',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                              foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 200.ms)
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _continueToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                              foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: const Text(
                              'Continue to App',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ).animate().fadeIn(delay: 400.ms),

                      if (!_locationFetched && !_isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: _continueToHome,
                              child: Text(
                                'Skip for now',
                                style: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade500, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
