import 'package:flutter/material.dart';
import '../models/address.dart';
import '../models/booking.dart';
import '../models/picker.dart';

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
      }
    });
  }
}
