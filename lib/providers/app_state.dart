import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/address.dart';
import '../models/booking.dart';
import '../models/picker.dart';
import '../models/notification.dart';

class AppState extends ChangeNotifier {
  final _notificationStreamController = StreamController<AppNotification>.broadcast();
  Stream<AppNotification> get notificationStream => _notificationStreamController.stream;

  // Check if Firebase was initialized successfully
  bool get isFirebaseEnabled {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

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
  String _userName = 'User';
  int _ecoPoints = 0;
  String _currentLocationAddress = '123 Green Valley Road, Eco Park, City Center';
  double _currentLatitude = 10.0159;
  double _currentLongitude = 76.3419;

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

  // Real-time Firestore subscriptions
  StreamSubscription? _pricesSub;
  StreamSubscription? _zonesSub;
  StreamSubscription? _offersSub;
  StreamSubscription? _bookingsSub;
  StreamSubscription? _userSub;
  StreamSubscription? _notifSub;
  StreamSubscription? _authSub;

  AppState() {
    startSync();
  }

  @override
  void dispose() {
    stopSync();
    super.dispose();
  }

  void startSync() {
    if (isFirebaseEnabled) {
      _startFirebaseSync();
    } else {
      _startMockSync();
    }
  }

  void stopSync() {
    _syncTimer?.cancel();
    _pricesSub?.cancel();
    _zonesSub?.cancel();
    _offersSub?.cancel();
    _bookingsSub?.cancel();
    _userSub?.cancel();
    _notifSub?.cancel();
    _authSub?.cancel();
  }

  void _startMockSync() {
    _loadFromDb();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _loadFromDb();
    });
  }

  void _startFirebaseSync() {
    // Shared configurations initialization
    _initFirestoreDefaults();

    // Listen to global configurations
    _pricesSub = FirebaseFirestore.instance.collection('scrap_prices').doc('rates').snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        _scrapPrices = Map<String, double>.from(
          snapshot.data()!.map((k, v) => MapEntry(k, (v as num).toDouble())),
        );
        notifyListeners();
      }
    });

    _zonesSub = FirebaseFirestore.instance.collection('coverage_zones').snapshots().listen((snapshot) {
      _coverageZones = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    });

    _offersSub = FirebaseFirestore.instance.collection('offers').snapshots().listen((snapshot) {
      _offers = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    });

    // Listen to Auth changes
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _listenToUserData(user.uid);
      } else {
        _clearUserData();
      }
    });
  }

  void _initFirestoreDefaults() {
    FirebaseFirestore.instance.collection('scrap_prices').doc('rates').get().then((doc) {
      if (!doc.exists) {
        FirebaseFirestore.instance.collection('scrap_prices').doc('rates').set({
          'Newspaper': 17.0,
          'Cardboard': 10.0,
          'Office Paper': 14.0,
          'Books': 16.0,
        });
      }
    });

    FirebaseFirestore.instance.collection('coverage_zones').get().then((snap) {
      if (snap.docs.isEmpty) {
        final defaultZones = [
          {"name": "Kochi", "status": "Fully operational", "active": true, "x": 0.55, "y": 0.58},
          {"name": "Thrissur", "status": "Fully operational", "active": true, "x": 0.48, "y": 0.44},
          {"name": "Calicut", "status": "Launching Q3 2026", "active": false, "x": 0.40, "y": 0.26},
          {"name": "Trivandrum", "status": "Launching Q4 2026", "active": false, "x": 0.45, "y": 0.85},
          {"name": "Kannur", "status": "Launching Q1 2027", "active": false, "x": 0.55, "y": 0.10}
        ];
        for (var z in defaultZones) {
          FirebaseFirestore.instance.collection('coverage_zones').doc(z['name'] as String).set(z);
        }
      }
    });

    FirebaseFirestore.instance.collection('offers').get().then((snap) {
      if (snap.docs.isEmpty) {
        final defaultOffers = [
          {
            "title": "Super Sunday",
            "desc": "Extra 2₹/kg on all paper items this Sunday!",
            "colorHex": "0xFF1D4ED8",
            "iconName": "sparkles",
            "modalTitle": "Super Sunday Special Boost",
            "modalDesc": "Get an extra ₹2 per kilogram on all newspaper, office paper, and cardboard recycled this Sunday only. Applies automatically to all pickups scheduled for Sunday.",
            "iconColorHex": "0xFFF59E0B"
          },
          {
            "title": "Eco Warrior",
            "desc": "Refer a friend and get 500 bonus points.",
            "colorHex": "0xFFD97706",
            "iconName": "users",
            "modalTitle": "Referral Rewards",
            "modalDesc": "Spread the green word! Share your referral link with a friend. Once they complete their first scrap pickup, both of you will receive 500 EcoPoints instantly.",
            "iconColorHex": "0xFFF97316"
          },
          {
            "title": "Cardboard King",
            "desc": "Special rates for bulk cardboard (50kg+).",
            "colorHex": "0xFF047857",
            "iconName": "crown",
            "modalTitle": "Bulk Cardboard Rates",
            "modalDesc": "Do you run a business or have packaging boxes in bulk? Schedule a bulk cardboard collection (50kg+) to unlock custom commercial rates and a free pickup vehicle.",
            "iconColorHex": "0xFFF59E0B"
          }
        ];
        for (var o in defaultOffers) {
          FirebaseFirestore.instance.collection('offers').add(o);
        }
      }
    });
  }

  void _listenToUserData(String uid) {
    _userSub?.cancel();
    _userSub = FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        _userName = data['fullName'] as String? ?? 'User';
        
        // Addresses
        if (data['addresses'] != null) {
          final List rawAddrs = data['addresses'] as List;
          _addresses = rawAddrs.map((a) => Address.fromJson(Map<String, dynamic>.from(a as Map))).toList();
        } else {
          _addresses = [];
        }

        // Active Subscription
        if (data['activeSubscription'] != null) {
          _activeSubscriptions = [Map<String, dynamic>.from(data['activeSubscription'] as Map)];
        } else {
          _activeSubscriptions = [];
        }

        _ecoPoints = data['ecoPoints'] as int? ?? 0;
        _currentLocationAddress = data['currentLocationAddress'] as String? ?? '123 Green Valley Road, Eco Park, City Center';
        _currentLatitude = (data['currentLatitude'] as num?)?.toDouble() ?? 10.0159;
        _currentLongitude = (data['currentLongitude'] as num?)?.toDouble() ?? 76.3419;
        
        notifyListeners();
      }
    });

    _notifSub?.cancel();
    _notifSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      final List<AppNotification> newNotifs = [];
      for (var doc in snapshot.docs) {
        newNotifs.add(AppNotification.fromJson(doc.data()));
      }

      // Detect new notifications
      if (_notifications.isNotEmpty && newNotifs.isNotEmpty) {
        for (var n in newNotifs) {
          if (!_notifications.any((oldN) => oldN.id == n.id)) {
            _notificationStreamController.add(n);
          }
        }
      }

      _notifications.clear();
      _notifications.addAll(newNotifs);
      notifyListeners();
    });

    _bookingsSub?.cancel();
    _bookingsSub = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      _bookings.clear();
      
      // Resolve drivers from Firestore collection
      FirebaseFirestore.instance.collection('pickers').get().then((pickerSnap) {
        final pickersList = pickerSnap.docs.map((d) => d.data()).toList();
        
        for (var doc in snapshot.docs) {
          var booking = Booking.fromJson(doc.data());
          if (booking.assignedPickerId != null) {
            final matchingIndex = pickersList.indexWhere(
              (p) => p['id'] == booking.assignedPickerId,
            );
            if (matchingIndex != -1) {
              booking = booking.copyWith(
                assignedPicker: Picker.fromJson(pickersList[matchingIndex]),
              );
            }
          }
          _bookings.add(booking);
        }
        notifyListeners();
      });
    });
  }

  void _clearUserData() {
    _userSub?.cancel();
    _bookingsSub?.cancel();
    _notifSub?.cancel();
    _addresses = [];
    _bookings.clear();
    _activeSubscriptions = [];
    _userName = 'User';
    notifyListeners();
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

        if (json['ecoPoints_zimu'] != null) {
          _ecoPoints = json['ecoPoints_zimu'] as int;
        }
        if (json['currentLocationAddress_zimu'] != null) {
          _currentLocationAddress = json['currentLocationAddress_zimu'] as String;
        }
        if (json['currentLatitude_zimu'] != null) {
          _currentLatitude = (json['currentLatitude_zimu'] as num).toDouble();
        }
        if (json['currentLongitude_zimu'] != null) {
          _currentLongitude = (json['currentLongitude_zimu'] as num).toDouble();
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

        // Write user metrics and current location settings
        json['ecoPoints_zimu'] = _ecoPoints;
        json['currentLocationAddress_zimu'] = _currentLocationAddress;
        json['currentLatitude_zimu'] = _currentLatitude;
        json['currentLongitude_zimu'] = _currentLongitude;

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

  int get ecoPoints => _ecoPoints;
  String get currentLocationAddress => _currentLocationAddress;
  double get currentLatitude => _currentLatitude;
  double get currentLongitude => _currentLongitude;

  void updateCurrentLocationAddress(String address, double lat, double lng) {
    _currentLocationAddress = address;
    _currentLatitude = lat;
    _currentLongitude = lng;
    if (isFirebaseEnabled && FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'currentLocationAddress': address,
        'currentLatitude': lat,
        'currentLongitude': lng,
      }, SetOptions(merge: true));
    } else {
      _saveToDb();
    }
    notifyListeners();
  }

  String get currentUserId {
    if (isFirebaseEnabled) {
      return FirebaseAuth.instance.currentUser?.uid ?? 'zimu';
    }
    return 'zimu';
  }

  String get userName {
    if (isFirebaseEnabled) {
      return _userName;
    }
    return 'zimu';
  }

  // Subscription helpers
  bool get isSubscribed => _activeSubscriptions.any((s) => s['userId'] == currentUserId && s['status'] == 'Active');
  String get currentSubscriptionPlan => isSubscribed 
      ? _activeSubscriptions.firstWhere((s) => s['userId'] == currentUserId && s['status'] == 'Active')['planType'] as String 
      : 'None';

  void subscribeToPlan(String planType, double price) {
    if (isFirebaseEnabled) {
      final uid = currentUserId;
      final subMap = {
        'id': 'sub_${DateTime.now().millisecondsSinceEpoch}',
        'userId': uid,
        'planType': planType,
        'price': price,
        'startDate': DateTime.now().toIso8601String(),
        'status': 'Active'
      };
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'activeSubscription': subMap,
      }, SetOptions(merge: true));
      
      addNotification(
        title: 'Subscription Activated!',
        message: 'You have successfully subscribed to the $planType plan (₹${price.toStringAsFixed(0)}/mo).',
        type: NotificationType.success,
      );
    } else {
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
  }

  void cancelSubscription() {
    if (isFirebaseEnabled) {
      final uid = currentUserId;
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'activeSubscription': FieldValue.delete(),
      });
      addNotification(
        title: 'Subscription Cancelled',
        message: 'Your active subscription has been cancelled.',
        type: NotificationType.warning,
      );
    } else {
      _activeSubscriptions.removeWhere((s) => s['userId'] == 'zimu');
      _saveToDb();
      notifyListeners();

      addNotification(
        title: 'Subscription Cancelled',
        message: 'Your active subscription has been cancelled.',
        type: NotificationType.warning,
      );
    }
  }

  void markAllNotificationsAsRead() {
    if (isFirebaseEnabled && FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .get()
          .then((snapshot) {
        final batch = FirebaseFirestore.instance.batch();
        for (var doc in snapshot.docs) {
          batch.update(doc.reference, {'isRead': true});
        }
        batch.commit();
      });
    } else {
      for (var n in _notifications) {
        n.isRead = true;
      }
      notifyListeners();
    }
  }

  void markNotificationAsRead(String id) {
    if (isFirebaseEnabled && FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(id)
          .update({'isRead': true});
    } else {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].isRead = true;
        notifyListeners();
      }
    }
  }

  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );

    if (isFirebaseEnabled && FirebaseAuth.instance.currentUser != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toJson());
    } else {
      _notifications.insert(0, notification);
      _notificationStreamController.add(notification);
      notifyListeners();
    }
  }

  // ── Dark/Light Mode ──
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
    if (isFirebaseEnabled) {
      final uid = currentUserId;
      List<Address> newAddrs = List.from(_addresses);
      if (address.isDefault) {
        newAddrs = newAddrs.map((a) => a.copyWith(isDefault: false)).toList();
      }
      newAddrs.add(address);
      
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'addresses': newAddrs.map((a) => a.toJson()).toList(),
      }, SetOptions(merge: true));
    } else {
      if (address.isDefault) {
        _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
      }
      _addresses.add(address);
      _saveToDb();
      notifyListeners();
    }
  }

  void updateAddress(Address address) {
    if (isFirebaseEnabled) {
      final uid = currentUserId;
      List<Address> newAddrs = List.from(_addresses);
      if (address.isDefault) {
        newAddrs = newAddrs.map((a) => a.copyWith(isDefault: false)).toList();
      }
      final index = newAddrs.indexWhere((a) => a.id == address.id);
      if (index != -1) {
        newAddrs[index] = address;
      }
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'addresses': newAddrs.map((a) => a.toJson()).toList(),
      }, SetOptions(merge: true));
    } else {
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
  }

  void deleteAddress(String id) {
    if (isFirebaseEnabled) {
      final uid = currentUserId;
      final newAddrs = List<Address>.from(_addresses)..removeWhere((a) => a.id == id);
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'addresses': newAddrs.map((a) => a.toJson()).toList(),
      }, SetOptions(merge: true));
    } else {
      _addresses.removeWhere((a) => a.id == id);
      _saveToDb();
      notifyListeners();
    }
  }

  void addBooking(Booking booking) {
    if (isFirebaseEnabled) {
      final uid = currentUserId;
      final docRef = FirebaseFirestore.instance.collection('bookings').doc();
      final finalBooking = booking.copyWith(
        id: docRef.id,
        userId: uid,
      );
      docRef.set(finalBooking.toJson());
      
      addNotification(
        title: 'Pickup Scheduled!',
        message: 'Your pickup has been scheduled successfully for ${booking.scrapType}.',
        type: NotificationType.success,
      );
    } else {
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

  void cancelBooking(String bookingId) {
    if (isFirebaseEnabled) {
      FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.cancelled.name,
      });
      addNotification(
        title: 'Pickup Cancelled',
        message: 'Your scheduled pickup has been cancelled.',
        type: NotificationType.warning,
      );
    } else {
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: BookingStatus.cancelled);
        _saveToDb();
        notifyListeners();
        addNotification(
          title: 'Pickup Cancelled',
          message: 'Your scheduled pickup has been cancelled.',
          type: NotificationType.warning,
        );
      }
    }
  }

  // ── Authentication Methods ──
  Future<void> signInWithIdentifierAndPassword(String identifier, String password) async {
    if (!isFirebaseEnabled) {
      _userName = identifier.contains('@') ? identifier.split('@')[0] : 'zimu';
      notifyListeners();
      return;
    }
    final email = _formatIdentifier(identifier);
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithIdentifierAndPassword(String name, String identifier, String password) async {
    if (!isFirebaseEnabled) {
      _userName = name;
      notifyListeners();
      return;
    }
    final email = _formatIdentifier(identifier);
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final user = userCredential.user;
    if (user != null) {
      final isEmail = identifier.contains('@');
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': name,
        'email': email,
        'mobileNumber': isEmail ? '' : identifier.trim(),
        'addresses': [],
        'activeSubscription': null,
        'ecoPoints': 0,
      });
    }
  }

  Future<void> signOut() async {
    if (isFirebaseEnabled) {
      await FirebaseAuth.instance.signOut();
      _clearUserData();
    } else {
      _userName = 'User';
      notifyListeners();
    }
  }

  String _formatIdentifier(String input) {
    final trimmed = input.trim();
    if (trimmed.contains('@')) {
      return trimmed;
    }
    final cleanPhone = trimmed.replaceAll(RegExp(r'\D'), '');
    return '$cleanPhone@reloop.com';
  }
}
