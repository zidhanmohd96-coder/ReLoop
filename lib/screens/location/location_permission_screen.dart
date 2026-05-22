import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';
import '../home_screen.dart';
import '../../core/services/location_service.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isLoading = false;
  bool _locationFetched = false;
  String _currentAddress = '123 Green Valley Road, Eco Park, City Center';
  double _lat = 0.0;
  double _long = 0.0;
  CameraPosition? userLocation;

  LatLng? _currentMapTarget;

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }
      Position position = await Geolocator.getCurrentPosition();
      
      final userLoc = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _isLoading = false;
        _locationFetched = true;
        _lat = position.latitude;
        _long = position.longitude;
        _currentAddress = userLoc.formattedAddress;
        _currentMapTarget = LatLng(position.latitude, position.longitude);
        userLocation = CameraPosition(
          target: _currentMapTarget!,
          zoom: 15,
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to fetch location: $e')));
      }
    }
  }

  Future<void> _confirmLocation() async {
    if (_currentMapTarget == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userLoc = await LocationService.getAddressFromLatLng(
        _currentMapTarget!.latitude,
        _currentMapTarget!.longitude,
      );

      setState(() {
        _lat = _currentMapTarget!.latitude;
        _long = _currentMapTarget!.longitude;
        _currentAddress = userLoc.formattedAddress;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location confirmed successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm location: $e')),
        );
      }
    }
  }

  void _liveLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((
      Position position,
    ) {
      if (mounted) {
        setState(() {
          _lat = position.latitude;
          _long = position.longitude;
          _currentAddress = '$_lat, $_long';
        });
      }
    });
  }

  void _continueToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  void _openInMaps() async {
    if (_lat.toString().isEmpty || _long.toString().isEmpty) return;
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$_lat,$_long',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open maps.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkBgGradient : AppTheme.lightBgGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Map Section
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: double.infinity,
                    decoration: AppTheme.getClayDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: 32,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: userLocation == null
                        // ? Center(
                        //     child: CircularProgressIndicator(
                        //       color: AppTheme.forestGreen,
                        //     ),
                        //   )
                        ? Stack(
                            children: [
                              // Dummy Map Background
                              Positioned.fill(
                                child: Opacity(
                                  opacity: isDark ? 0.3 : 0.5,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Overlay Gradient
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        (isDark
                                                ? const Color(0xFF1E293B)
                                                : Colors.white)
                                            .withOpacity(0.1),
                                        (isDark
                                                ? const Color(0xFF1E293B)
                                                : Colors.white)
                                            .withOpacity(0.8),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              // Center Pin
                              if (_locationFetched)
                                Center(
                                  child:
                                      Icon(
                                        LucideIcons.mapPin,
                                        size: 48,
                                        color: isDark
                                            ? AppTheme.mintGreen
                                            : AppTheme.forestGreen,
                                      ).animate().scale(
                                        curve: Curves.elasticOut,
                                        duration: 800.ms,
                                      ),
                                )
                              else if (_isLoading)
                                Center(
                                  child: CircularProgressIndicator(
                                    color: isDark
                                        ? AppTheme.mintGreen
                                        : AppTheme.forestGreen,
                                  ),
                                )
                              else
                                Center(
                                  child:
                                      const Icon(
                                            LucideIcons.map,
                                            size: 48,
                                            color: Colors.grey,
                                          )
                                          .animate(
                                            onPlay: (controller) => controller
                                                .repeat(reverse: true),
                                          )
                                          .shimmer(duration: 2000.ms),
                                ),
                            ],
                          )
                        : Stack(
                            children: [
                              GoogleMap(
                                initialCameraPosition: userLocation!,
                                myLocationEnabled: true,
                                onCameraMove: (position) {
                                  _currentMapTarget = position.target;
                                },
                                onCameraIdle: () {
                                  if (_currentMapTarget != null) {
                                    setState(() {
                                      _lat = _currentMapTarget!.latitude;
                                      _long = _currentMapTarget!.longitude;
                                    });
                                  }
                                },
                              ),
                              IgnorePointer(
                                child: Center(
                                  child: Icon(
                                    Icons.location_pin,
                                    size: 38,
                                    color: AppTheme.forestGreen,
                                  )
                                  .animate(
                                    onPlay: (controller) => controller
                                        .repeat(reverse: true),
                                  )
                                  .shimmer(duration: 2000.ms),
                                ),
                              ),
                            ],
                          ),
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),
              ),

              // Bottom Content Section
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                    border: isDark
                        ? Border.all(
                            color: Colors.white.withOpacity(0.08),
                            width: 1,
                          )
                        : null,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      const SizedBox(height: 16),
                      Text(
                        _locationFetched
                            ? 'Location Found!'
                            : 'Enable Location',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.forestGreen,
                        ),
                      ).animate(target: _locationFetched ? 1 : 0).fadeIn(),
                      const SizedBox(height: 16),
                      Text(
                        _locationFetched
                            ? 'We have successfully fetched your exact location. You are ready to schedule your first pickup!. You can also move the pin to your exact location and click on confirm location button below.'
                            : 'To provide you with accurate scrap prices and connect you with nearby pickup staff, we need your location.',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Address Details (Only when fetched)
                      if (_locationFetched)
                        Container(
                              padding: const EdgeInsets.all(24),
                              decoration: AppTheme.getClayDecoration(
                                color: isDark
                                    ? const Color(0xFF0F172A)
                                    : AppTheme.softBeige,
                                borderRadius: 24,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          (isDark
                                                  ? AppTheme.mintGreen
                                                  : AppTheme.leafGreen)
                                              .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      LucideIcons.navigation,
                                      color: isDark
                                          ? AppTheme.mintGreen
                                          : AppTheme.forestGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Current Address',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey.shade500
                                                : Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _currentAddress,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : AppTheme.forestGreen,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Coordinates: ${_lat.toStringAsFixed(6)}, ${_long.toStringAsFixed(6)}',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey.shade400
                                                : Colors.grey.shade600,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 24),

                      // Action Buttons
                      if (!_locationFetched)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    await _fetchLocation();
                                  },
                            icon: const Icon(LucideIcons.mapPin, size: 20),
                            label: const Text(
                              'Use Current Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppTheme.mintGreen
                                  : AppTheme.forestGreen,
                              foregroundColor: isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 200.ms)
                      else
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _confirmLocation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? AppTheme.mintGreen
                                      : AppTheme.forestGreen,
                                  foregroundColor: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                child: const Text(
                                  'Confirm the location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: 400.ms),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _continueToHome,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? AppTheme.mintGreen
                                      : AppTheme.forestGreen,
                                  foregroundColor: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                child: const Text(
                                  'Continue to App',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: 400.ms),
                          ],
                        ),

                      if (!_locationFetched && !_isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: _continueToHome,
                              child: Text(
                                'Skip for now',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
