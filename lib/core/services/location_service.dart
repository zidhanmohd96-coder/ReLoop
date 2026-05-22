import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserLocation {
  final double latitude;
  final double longitude;
  final String city;
  final String region;
  final String country;
  final String zip;
  final String query;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.region,
    required this.country,
    required this.zip,
    required this.query,
  });

  String get formattedAddress {
    if (city.isEmpty) return 'Eco Green Valley, Eco Park, Cochin';
    return '$zip, $city, $region, $country';
  }

  factory UserLocation.keralaDefault() {
    return UserLocation(
      latitude: 9.9312,
      longitude: 76.2673,
      city: 'Cochin',
      region: 'Kerala',
      country: 'India',
      zip: '682030',
      query: '127.0.0.1',
    );
  }
}

class LocationService {
  static Future<UserLocation> getCurrentLocation() async {
    if (kIsWeb) {
      // 1. Bypass Geolocator to prevent Platform._version errors on Web/Chrome
      try {
        final url = Uri.parse('http://ip-api.com/json');
        final response = await http.get(url).timeout(const Duration(seconds: 4));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'success') {
            return UserLocation(
              latitude: (data['lat'] as num).toDouble(),
              longitude: (data['lon'] as num).toDouble(),
              city: data['city'] ?? 'Cochin',
              region: data['regionName'] ?? 'Kerala',
              country: data['country'] ?? 'India',
              zip: data['zip'] ?? '682030',
              query: data['query'] ?? '',
            );
          }
        }
      } catch (_) {}
      return UserLocation.keralaDefault();
    }

    try {
      // 2. Mobile/Native - Geolocator permissions & get position
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 5),
          );

          // Reverse geocode using OpenStreetMap Nominatim API (Free & No Key required)
          final nominatimUrl = Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1',
          );
          final response = await http.get(
            nominatimUrl,
            headers: {'User-Agent': 'ReLoopApp/1.0 (contact: support@reloop.com)'},
          ).timeout(const Duration(seconds: 4));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final address = data['address'] as Map<String, dynamic>?;
            if (address != null) {
              final city = address['city'] ??
                  address['town'] ??
                  address['village'] ??
                  address['suburb'] ??
                  address['county'] ??
                  'Cochin';
              final region = address['state'] ?? 'Kerala';
              final country = address['country'] ?? 'India';
              final zip = address['postcode'] ?? '682030';

              return UserLocation(
                latitude: position.latitude,
                longitude: position.longitude,
                city: city.toString(),
                region: region.toString(),
                country: country.toString(),
                zip: zip.toString(),
                query: 'GPS',
              );
            }
          }
        }
      }
    } catch (e) {
      // Fall back to IP Geolocation on error
    }

    // 3. Fallback to free IP location
    try {
      final url = Uri.parse('http://ip-api.com/json');
      final response = await http.get(url).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return UserLocation(
            latitude: (data['lat'] as num).toDouble(),
            longitude: (data['lon'] as num).toDouble(),
            city: data['city'] ?? 'Cochin',
            region: data['regionName'] ?? 'Kerala',
            country: data['country'] ?? 'India',
            zip: data['zip'] ?? '682030',
            query: data['query'] ?? '',
          );
        }
      }
    } catch (_) {}

    // 4. Ultimate fallback to Default Kerala Location
    return UserLocation.keralaDefault();
  }
}
