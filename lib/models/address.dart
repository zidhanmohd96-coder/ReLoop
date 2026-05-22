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
  final String label; // e.g. 'Home', 'Office', 'Other'

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
    this.label = 'Home',
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
    String? label,
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
      label: label ?? this.label,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String?,
      fullName: json['fullName'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      houseName: json['houseName'] as String? ?? '',
      area: json['area'] as String? ?? '',
      landmark: json['landmark'] as String? ?? '',
      city: json['city'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isDefault: json['isDefault'] as bool? ?? false,
      label: json['label'] as String? ?? 'Home',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'houseName': houseName,
      'area': area,
      'landmark': landmark,
      'city': city,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'label': label,
    };
  }

  String get addressLine {
    return '$houseName, $area, $city - $pincode';
  }
}
