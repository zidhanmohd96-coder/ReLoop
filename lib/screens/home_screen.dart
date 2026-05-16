import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state.dart';
import '../theme.dart';
import 'address_management_screen.dart';
import 'booking_flow_screen.dart';

part 'tabs/home_tab.dart';
part 'tabs/bookings_tab.dart';
part 'tabs/rewards_tab.dart';
part 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _offersPageController = PageController();
  final PageController _mainPageController = PageController();
  int _currentOfferIndex = 0;
  Timer? _offersTimer;
  bool _isServiceAvailable = true;

  final List<Map<String, dynamic>> _offers = [
    {
      'title': 'Super Sunday',
      'desc': 'Extra 2₹/kg on all paper items this\nSunday!',
      'color': const Color(0xFF1D4ED8),
      'icon': LucideIcons.sparkles,
      'modalTitle': 'Super Sunday',
      'modalDesc': 'Extra 2₹/kg on all paper items this Sunday!',
      'iconColor': Colors.amber,
    },
    {
      'title': 'Eco Warrior',
      'desc': 'Refer a friend and get 500 bonus points.',
      'color': const Color(0xFFD97706),
      'icon': LucideIcons.users,
      'modalTitle': 'Eco Warrior',
      'modalDesc': 'Refer a friend and get 500 bonus points.',
      'iconColor': Colors.orange,
    },
    {
      'title': 'Cardboard King',
      'desc': 'Special rates for bulk cardboard (50kg+).',
      'color': const Color(0xFF047857),
      'icon': LucideIcons.crown,
      'modalTitle': 'Cardboard King',
      'modalDesc': 'Special rates for bulk cardboard (50kg+).',
      'iconColor': Colors.amber,
    },
  ];

  @override
  void initState() {
    super.initState();
    _offersTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_offersPageController.hasClients) {
        _currentOfferIndex = (_currentOfferIndex + 1) % _offers.length;
        _offersPageController.animateToPage(
          _currentOfferIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _offersTimer?.cancel();
    _offersPageController.dispose();
    _mainPageController.dispose();
    super.dispose();
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
                  _buildHomeTab(context).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                  _buildBookingsTab(context).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                  _buildRewardsTab(context).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                  _buildProfileTab(context).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                ],
              ),
              Positioned(
                left: 32,
                right: 32,
                bottom: 32,
                child: _buildFloatingNavBar(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingNavBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, LucideIcons.home, isDark),
          _buildNavItem(1, LucideIcons.calendar, isDark),
          _buildNavItem(2, LucideIcons.trophy, isDark),
          _buildNavItem(3, LucideIcons.user, isDark),
        ],
      ),
    ).animate().slideY(begin: 1.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildNavItem(int index, IconData icon, bool isDark) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        _mainPageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuint,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
            ? (isDark ? AppTheme.mintGreen : AppTheme.forestGreen) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          icon,
          color: isSelected 
            ? (isDark ? const Color(0xFF0F172A) : Colors.white) 
            : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
        ),
      ),
    );
  }
}