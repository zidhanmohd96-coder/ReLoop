import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/address.dart';
import '../models/booking.dart';
import '../models/picker.dart';
import '../models/notification.dart';

class AppState extends ChangeNotifier {
  List<Address> _addresses = [
    Address(
      id: 'addr_default_1',
      fullName: 'zimu',
      mobileNumber: '9876543210',
      houseName: 'Green Villa',
      area: 'Kakkanad',
      landmark: 'Near InfoPark',
      city: 'Kochi',
      pincode: '682030',
      latitude: 10.0159,
      longitude: 76.3419,
      isDefault: true,
      label: 'Home',
    ),
  ];
  
  final List<Booking> _bookings = [];
  Map<String, double> _scrapPrices = {
    'Newspaper': 17.0,
    'Cardboard': 10.0,
    'Office Paper': 14.0,
    'Books': 16.0,
  };
  List<Map<String, dynamic>> _coverageZones = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _activeSubscriptions = [];

  // ── Notifications State ──
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Welcome to ReLoop!',
      message: 'Start recycling plastic, paper, and metal to earn sustainable green points.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.success,
    ),
    AppNotification(
      id: 'n2',
      title: 'Eco Warrior Achievement',
      message: 'Congratulations! You achieved Level 2 Eco Warrior by saving 15kg of CO2 emissions.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.points,
    ),
  ];

  Timer? _syncTimer;

  AppState() {
    startSync();
  }

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }

  void startSync() {
    _loadFromDb();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _loadFromDb();
    });
  }

  void stopSync() {
    _syncTimer?.cancel();
  }

  void _loadFromDb() {
    try {
      final file = File('d:/ZilZila/Coding-Projects/Flutter-Projects/mock_db.json');
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;

        // Load scrap prices
        if (json['scrapPrices'] != null) {
          _scrapPrices = Map<String, double>.from(
            (json['scrapPrices'] as Map).map((k, v) => MapEntry(k as String, (v as num).toDouble())),
          );
        }

        // Load coverage zones
        if (json['coverageZones'] != null) {
          _coverageZones = List<Map<String, dynamic>>.from(json['coverageZones']);
        }

        // Load offers
        if (json['offers'] != null) {
          _offers = List<Map<String, dynamic>>.from(json['offers']);
        }

        // Load active subscriptions
        if (json['activeSubscriptions'] != null) {
          _activeSubscriptions = List<Map<String, dynamic>>.from(json['activeSubscriptions']);
        }

        // Load user addresses if saved in DB
        if (json['userAddresses_zimu'] != null) {
          final rawAddrs = json['userAddresses_zimu'] as List;
          _addresses = rawAddrs.map((a) => Address.fromJson(a as Map<String, dynamic>)).toList();
        }

        // Load bookings
        if (json['bookings'] != null) {
          final rawBookings = json['bookings'] as List;
          final loadedBookings = rawBookings.map((b) {
            final booking = Booking.fromJson(b as Map<String, dynamic>);
            // Resolve assigned picker
            if (booking.assignedPickerId != null && json['pickers'] != null) {
              final rawPickers = json['pickers'] as List;
              final matching = rawPickers.firstWhere(
                (p) => (p as Map)['id'] == booking.assignedPickerId,
                orElse: () => null,
              );
              if (matching != null) {
                return booking.copyWith(
                  assignedPicker: Picker.fromJson(matching as Map<String, dynamic>),
                );
              }
            }
            return booking;
          }).toList();

          // Check if there are changes before notifying to prevent infinite redraw loops
          bool hasChanged = _bookings.length != loadedBookings.length;
          if (!hasChanged) {
            for (int i = 0; i < _bookings.length; i++) {
              if (_bookings[i].status != loadedBookings[i].status ||
                  _bookings[i].assignedPicker?.id != loadedBookings[i].assignedPicker?.id ||
                  _bookings[i].totalPayoutAmount != loadedBookings[i].totalPayoutAmount ||
                  _bookings[i].assignedPickerId != loadedBookings[i].assignedPickerId) {
                hasChanged = true;
                break;
              }
            }
          }
          if (hasChanged) {
            // Find if any booking status has upgraded and raise notification
            for (var lb in loadedBookings) {
              final existingIndex = _bookings.indexWhere((eb) => eb.id == lb.id);
              if (existingIndex != -1) {
                final oldB = _bookings[existingIndex];
                if (oldB.status != lb.status) {
                  _triggerStatusNotification(lb);
                }
              }
            }

            _bookings.clear();
            _bookings.addAll(loadedBookings);
            notifyListeners();
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading from mock db: $e');
    }
  }

  void _triggerStatusNotification(Booking booking) {
    String title = 'Booking Update';
    String message = 'Your pickup booking status is now ${booking.status.toString().split('.').last}.';
    NotificationType type = NotificationType.info;

    if (booking.status == BookingStatus.assigned && booking.assignedPicker != null) {
      title = 'Driver Assigned!';
      message = '${booking.assignedPicker!.name} (${booking.assignedPicker!.vehicleNumber}) has been assigned to your pickup.';
      type = NotificationType.info;
    } else if (booking.status == BookingStatus.onTheWay) {
      title = 'Driver On The Way!';
      message = 'Our agent is heading towards your location.';
      type = NotificationType.info;
    } else if (booking.status == BookingStatus.completed) {
      title = 'Pickup Completed!';
      message = 'Thank you for recycling! You earned eco points for ${booking.totalPayoutAmount} payout.';
      type = NotificationType.success;
    }

    addNotification(title: title, message: message, type: type);
  }

  void _saveToDb() {
    try {
      final file = File('d:/ZilZila/Coding-Projects/Flutter-Projects/mock_db.json');
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;

        // Write our current bookings
        json['bookings'] = _bookings.map((b) => b.toJson()).toList();

        // Write our active subscriptions
        json['activeSubscriptions'] = _activeSubscriptions;

        // Write user addresses
        json['userAddresses_zimu'] = _addresses.map((a) => a.toJson()).toList();

        // Save back
        file.writeAsStringSync(jsonEncode(json));
      }
    } catch (e) {
      debugPrint('Error saving to mock db: $e');
    }
  }

  // ── Getters ──
  List<AppNotification> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  List<Address> get addresses => _addresses;
  List<Booking> get bookings => _bookings;
  Map<String, double> get scrapPrices => _scrapPrices;
  List<Map<String, dynamic>> get coverageZones => _coverageZones.isNotEmpty ? _coverageZones : [
    {"name": "Kochi", "status": "Fully operational", "active": true, "x": 0.55, "y": 0.58},
    {"name": "Thrissur", "status": "Fully operational", "active": true, "x": 0.48, "y": 0.44},
    {"name": "Calicut", "status": "Launching Q3 2026", "active": false, "x": 0.40, "y": 0.26},
    {"name": "Trivandrum", "status": "Launching Q4 2026", "active": false, "x": 0.45, "y": 0.85},
    {"name": "Kannur", "status": "Launching Q1 2027", "active": false, "x": 0.55, "y": 0.10}
  ];
  List<Map<String, dynamic>> get offers => _offers;
  List<Map<String, dynamic>> get activeSubscriptions => _activeSubscriptions;

  // Subscription helpers
  bool get isSubscribed => _activeSubscriptions.any((s) => s['userId'] == 'zimu' && s['status'] == 'Active');
  String get currentSubscriptionPlan => isSubscribed 
      ? _activeSubscriptions.firstWhere((s) => s['userId'] == 'zimu' && s['status'] == 'Active')['planType'] as String 
      : 'None';

  void subscribeToPlan(String planType, double price) {
    _activeSubscriptions.removeWhere((s) => s['userId'] == 'zimu');
    
    _activeSubscriptions.add({
      'id': 'sub_${DateTime.now().millisecondsSinceEpoch}',
      'userId': 'zimu',
      'planType': planType,
      'price': price,
      'startDate': DateTime.now().toIso8601String(),
      'status': 'Active'
    });

    _saveToDb();
    notifyListeners();

    addNotification(
      title: 'Subscription Activated!',
      message: 'You have successfully subscribed to the $planType plan (₹${price.toStringAsFixed(0)}/mo).',
      type: NotificationType.success,
    );
  }

  void cancelSubscription() {
    _activeSubscriptions.removeWhere((s) => s['userId'] == 'zimu');
    _saveToDb();
    notifyListeners();

    addNotification(
      title: 'Subscription Cancelled',
      message: 'Your active subscription has been cancelled.',
      type: NotificationType.warning,
    );
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().toIso8601String(),
        title: title,
        message: message,
        timestamp: DateTime.now(),
        type: type,
      ),
    );
    notifyListeners();
  }

  // ── Dark Mode ──
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void addAddress(Address address) {
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses.add(address);
    _saveToDb();
    notifyListeners();
  }

  void updateAddress(Address address) {
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      _addresses[index] = address;
      _saveToDb();
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    _saveToDb();
    notifyListeners();
  }

  void addBooking(Booking booking) {
    _bookings.add(booking);
    _saveToDb();
    notifyListeners();

    addNotification(
      title: 'Pickup Scheduled!',
      message: 'Your pickup has been scheduled successfully for ${booking.scrapType}.',
      type: NotificationType.success,
    );
  }
}
