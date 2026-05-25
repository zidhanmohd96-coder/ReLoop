import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../features/home/presentation/screens/home_tab.dart';
import '../features/bookings/presentation/tabs/bookings_tab.dart';
import '../features/rewards/presentation/tabs/rewards_tab.dart';
import '../features/profile/presentation/tabs/profile_tab.dart';
import '../providers/app_state.dart';
import '../models/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _mainPageController = PageController();
  StreamSubscription? _notifSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      _notifSubscription = appState.notificationStream.listen((notification) {
        _showInAppNotificationSnackBar(notification);
      });
    });
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    _mainPageController.dispose();
    super.dispose();
  }

  void _showInAppNotificationSnackBar(AppNotification notification) {
    if (!mounted) return;
    
    Color accentColor;
    IconData icon;
    
    switch (notification.type) {
      case NotificationType.success:
        accentColor = const Color(0xFF10B981); // Emerald Green
        icon = Icons.check_circle_rounded;
        break;
      case NotificationType.warning:
        accentColor = const Color(0xFFF59E0B); // Amber
        icon = Icons.warning_rounded;
        break;
      case NotificationType.points:
        accentColor = const Color(0xFF6366F1); // Indigo
        icon = Icons.stars_rounded;
        break;
      default:
        accentColor = const Color(0xFF0D9488); // Teal
        icon = Icons.info_rounded;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 90), // Display above the navigation bar
      ),
    );
  }

  void _navigateToTab(int index) {
    _mainPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuint,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkBgGradient : AppTheme.lightBgGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              PageView(
                controller: _mainPageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  const HomeTab().animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                  const BookingsTab().animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                  const RewardsTab().animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                  ProfileTab(
                    onViewHistory: () {
                      _navigateToTab(1);
                    },
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                ],
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.06,
                right: MediaQuery.of(context).size.width * 0.06,
                bottom: 24,
                child: _buildFloatingNavBar(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingNavBar(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hPad = constraints.maxWidth < 320 ? 12.0 : 16.0;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B).withOpacity(0.9) : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildNavItem(0, LucideIcons.home, isDark)),
              Expanded(child: _buildNavItem(1, LucideIcons.calendar, isDark)),
              Expanded(child: _buildNavItem(2, LucideIcons.trophy, isDark)),
              Expanded(child: _buildNavItem(3, LucideIcons.user, isDark)),
            ],
          ),
        );
      },
    ).animate().slideY(begin: 1.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildNavItem(int index, IconData icon, bool isDark) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _navigateToTab(index),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected 
              ? (isDark ? AppTheme.mintGreen : AppTheme.forestGreen) 
              : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isSelected 
              ? (isDark ? const Color(0xFF0F172A) : Colors.white) 
              : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}