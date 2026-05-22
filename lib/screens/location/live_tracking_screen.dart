import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../models/booking.dart';
import '../../providers/app_state.dart';
import '../../theme.dart';

class LiveTrackingScreen extends StatelessWidget {
  final String bookingId;

  const LiveTrackingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'Live Status',
              style: TextStyle(
                color: AppTheme.forestGreen,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '#${bookingId.substring(0, bookingId.length < 6 ? bookingId.length : 6).toUpperCase()}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                LucideIcons.chevronLeft,
                color: AppTheme.forestGreen,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final booking = state.bookings.firstWhere((b) => b.id == bookingId);

          return Stack(
            children: [
              Positioned.fill(child: _buildMap(booking)),
              Positioned(
                left: 24,
                right: 24,
                bottom: 120, // Leave space for the mock nav bar or buttons
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatusCard(booking),
                    const SizedBox(height: 16),
                    if (booking.instructions != null &&
                        booking.instructions!.isNotEmpty) ...[
                      _buildInstructionsCard(booking.instructions!),
                      const SizedBox(height: 16),
                    ],
                    _buildReportIssueButton(),
                  ],
                ),
              ),
              Positioned(
                left: 32,
                right: 32,
                bottom: 32,
                child:
                    _buildFloatingNavBar(), // Mock nav bar to match screenshot
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(Booking booking) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          booking.address.latitude,
          booking.address.longitude,
        ),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.reloop.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(
                booking.address.latitude,
                booking.address.longitude,
              ),
              width: 40,
              height: 40,
              child: const Icon(
                LucideIcons.mapPin,
                color: AppTheme.leafGreen,
                size: 40,
              ),
            ),
            if (booking.assignedPicker != null)
              Marker(
                point: LatLng(
                  booking.address.latitude - 0.002,
                  booking.address.longitude - 0.002,
                ),
                width: 40,
                height: 40,
                child: const Icon(
                  LucideIcons.truck,
                  color: AppTheme.forestGreen,
                  size: 40,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.leafGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.checkCircle2,
                  color: AppTheme.leafGreen,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Confirmed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.forestGreen,
                    ),
                  ),
                  Text(
                    'AWAITING STAFF ASSIGNMENT',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimelineStep(
            'PENDING',
            isActive:
                booking.status == BookingStatus.pending ||
                booking.status == BookingStatus.assigned,
            isFirst: true,
          ),
          _buildTimelineStep(
            'ASSIGNED',
            isActive:
                booking.status == BookingStatus.assigned ||
                booking.status == BookingStatus.onTheWay,
          ),
          _buildTimelineStep(
            'ON THE WAY',
            isActive:
                booking.status == BookingStatus.onTheWay ||
                booking.status == BookingStatus.pickupStarted,
          ),
          _buildTimelineStep(
            'COMPLETED',
            isActive: booking.status == BookingStatus.completed,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    String title, {
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.forestGreen : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isActive ? AppTheme.forestGreen : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            color: isActive ? AppTheme.forestGreen : Colors.grey.shade400,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsCard(String instructions) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PICKUP INSTRUCTIONS',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"$instructions"',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: AppTheme.forestGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportIssueButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.forestGreen,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: const Text('Report an Issue'),
    );
  }

  Widget _buildFloatingNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.home,
                color: AppTheme.forestGreen,
                size: 24,
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.forestGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Icon(
            LucideIcons.calendar,
            color: AppTheme.lightGreen,
            size: 24,
          ),
          const Icon(LucideIcons.trophy, color: AppTheme.lightGreen, size: 24),
          const Icon(LucideIcons.user, color: AppTheme.lightGreen, size: 24),
        ],
      ),
    );
  }
}
