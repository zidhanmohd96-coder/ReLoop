import 'package:uuid/uuid.dart';

class Address {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String houseName;
  final String area;
  final String landmark;
  final String city;
  final String pincode;
  final double latitude;
  final double longitude;
  final bool isDefault;

  Address({
    String? id,
    required this.fullName,
    required this.mobileNumber,
    required this.houseName,
    required this.area,
    required this.landmark,
    required this.city,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  }) : id = id ?? const Uuid().v4();

  Address copyWith({
    String? fullName,
    String? mobileNumber,
    String? houseName,
    String? area,
    String? landmark,
    String? city,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return Address(
      id: id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      houseName: houseName ?? this.houseName,
      area: area ?? this.area,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
