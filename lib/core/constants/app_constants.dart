import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppConstants {
  // ── APP GLOBAL DETAILS ──
  static const String appName = 'ReLoop';
  static const String appTagline = 'PREMIUM RECYCLING';

  // ── PRICING DATA ──
  static const Map<String, double> scrapPrices = {
    'Newspaper': 17.0,
    'Cardboard': 10.0,
    'Office Paper': 14.0,
    'Books': 16.0,
  };

  static const List<Map<String, dynamic>> pricingItems = [
    {
      'name': 'Paper',
      'price': '₹17',
      'icon': LucideIcons.bookOpen,
      'details': 'Includes old newspapers, magazines, and notebooks. Please ensure they are dry and not contaminated with food waste.',
    },
    {
      'name': 'Cardboard',
      'price': '₹10',
      'icon': LucideIcons.package,
      'details': 'Shipping boxes, packaging, and brown paper. Please flatten the boxes to save space.',
    },
    {
      'name': 'Books',
      'price': '₹16',
      'icon': LucideIcons.library,
      'details': 'Old textbooks, novels, and hardbounds. Heavily damaged or missing covers are also accepted.',
    },
  ];

  // ── QUANTITY ESTIMATES ──
  static const List<String> quantities = [
    'Small (<5kg)',
    'Medium (5-20kg)',
    'Large (20kg+)',
  ];

  static const Map<String, List<double>> quantityRanges = {
    'Small (<5kg)': [2, 5],
    'Medium (5-20kg)': [5, 20],
    'Large (20kg+)': [20, 50],
  };

  // ── COVERAGE & COVERAGE DATA ──
  static const List<Map<String, dynamic>> coverageZones = [
    {'name': 'Kochi', 'status': 'Fully operational', 'active': true, 'x': 0.55, 'y': 0.58},
    {'name': 'Thrissur', 'status': 'Fully operational', 'active': true, 'x': 0.48, 'y': 0.44},
    {'name': 'Calicut', 'status': 'Launching Q3 2026', 'active': false, 'x': 0.40, 'y': 0.26},
    {'name': 'Trivandrum', 'status': 'Launching Q4 2026', 'active': false, 'x': 0.45, 'y': 0.85},
    {'name': 'Kannur', 'status': 'Launching Q1 2027', 'active': false, 'x': 0.55, 'y': 0.10},
  ];

  // ── CUSTOMER REVIEWS ──
  static const List<Map<String, dynamic>> customerReviews = [
    {
      'name': 'Salman Nazeer.',
      'review': 'Very professional and on time. Highly recommended!',
      'rating': 5,
    },
    {
      'name': 'Sadiq.',
      'review': 'Great app to recycle old newspapers. Got my eco points instantly.',
      'rating': 5,
    },
    {
      'name': 'Sulaiman.',
      'review': 'The picker was polite and the whole process was smooth.',
      'rating': 4,
    },
  ];

  // ── OFFERS DATA ──
  static const List<Map<String, dynamic>> offers = [
    {
      'title': 'Super Sunday',
      'desc': 'Extra 2₹/kg on all paper items this\nSunday!',
      'color': Color(0xFF1D4ED8),
      'icon': LucideIcons.sparkles,
      'modalTitle': 'Super Sunday',
      'modalDesc': 'Extra 2₹/kg on all paper items this Sunday!',
      'iconColor': Colors.amber,
    },
    {
      'title': 'Eco Warrior',
      'desc': 'Refer a friend and get 500 bonus points.',
      'color': Color(0xFFD97706),
      'icon': LucideIcons.users,
      'modalTitle': 'Eco Warrior',
      'modalDesc': 'Refer a friend and get 500 bonus points.',
      'iconColor': Colors.orange,
    },
    {
      'title': 'Cardboard King',
      'desc': 'Special rates for bulk cardboard (50kg+).',
      'color': Color(0xFF047857),
      'icon': LucideIcons.crown,
      'modalTitle': 'Cardboard King',
      'modalDesc': 'Special rates for bulk cardboard (50kg+).',
      'iconColor': Colors.amber,
    },
  ];
}
