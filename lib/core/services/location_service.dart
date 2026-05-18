import 'dart:convert';
import 'package:http/http.dart' as http;

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
    } catch (_) {
      // Gracefully handle timeout, no internet, or platform constraints
    }
    return UserLocation.keralaDefault();
  }
}

