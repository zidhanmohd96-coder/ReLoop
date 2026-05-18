import 'package:flutter/material.dart';
import '../models/address.dart';
import '../models/booking.dart';
import '../models/picker.dart';
import '../models/notification.dart';

class AppState extends ChangeNotifier {
  List<Address> _addresses = [
    Address(
      fullName: 'John Doe',
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
    AppNotification(
      id: 'n3',
      title: 'Upcoming Scheduled Pickup',
      message: 'Your Paper & Cardboard pickup is scheduled for Wed, 14 May.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.info,
    ),
  ];

  List<AppNotification> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

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

  List<Address> get addresses => _addresses;
  List<Booking> get bookings => _bookings;

  void addAddress(Address address) {
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses.add(address);
    notifyListeners();
  }

  void updateAddress(Address address) {
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      _addresses[index] = address;
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();

    // Trigger immediate schedule notification
    addNotification(
      title: 'Pickup Scheduled!',
      message: 'Your pickup has been scheduled successfully for ${booking.scrapType}.',
      type: NotificationType.success,
    );

    // Simulate assigning a picker after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      final picker = Picker(
        id: 'p1',
        name: 'Ramesh Kumar',
        photoUrl: 'https://i.pravatar.cc/150?u=ramesh',
        mobileNumber: '9988776655',
        vehicleNumber: 'KL 07 AB 1234',
        rating: 4.8,
      );

      final index = _bookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: BookingStatus.assigned,
          assignedPicker: picker,
        );
        notifyListeners();

        // Trigger picker assignment notification
        addNotification(
          title: 'Driver Assigned!',
          message: '${picker.name} (${picker.vehicleNumber}) has been assigned to your ${booking.scrapType} pickup.',
          type: NotificationType.info,
        );
      }
    });
  }
}
