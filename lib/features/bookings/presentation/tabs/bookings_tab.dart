import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import '../../../../providers/app_state.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../models/booking.dart';

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hPad = context.scalePadding(24.0);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final allBookings = appState.bookings;

        // Categorize bookings
        final upcomingBookings = allBookings.where((b) =>
            b.status != BookingStatus.completed &&
            b.status != BookingStatus.cancelled).toList();

        final completedBookings = allBookings.where((b) =>
            b.status == BookingStatus.completed).toList();

        final cancelledBookings = allBookings.where((b) =>
            b.status == BookingStatus.cancelled).toList();

        return DefaultTabController(
          length: 3,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(hPad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickups',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.forestGreen,
                        ),
                      ),
                      Text(
                        'YOUR RECYCLING JOURNEY',
                        style: TextStyle(
                          color: AppTheme.mintGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: hPad),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    labelColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                    unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Upcoming Tab
                      _buildBookingsList(context, upcomingBookings, 'No upcoming pickups', isDark, hPad),
                      // Completed Tab
                      _buildBookingsList(context, completedBookings, 'No completed pickups yet', isDark, hPad),
                      // Cancelled Tab
                      _buildBookingsList(context, cancelledBookings, 'No cancelled pickups', isDark, hPad),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<Booking> list,
    String emptyMessage,
    bool isDark,
    double hPad,
  ) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.calendarX,
              size: 48,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 120),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];

        Color statusColor = Colors.orange.shade400;
        IconData statusIcon = LucideIcons.clock;

        switch (booking.status) {
          case BookingStatus.pending:
            statusColor = Colors.amber.shade600;
            statusIcon = LucideIcons.clock;
            break;
          case BookingStatus.assigned:
            statusColor = Colors.blue.shade400;
            statusIcon = LucideIcons.userCheck;
            break;
          case BookingStatus.onTheWay:
            statusColor = Colors.indigo.shade400;
            statusIcon = LucideIcons.truck;
            break;
          case BookingStatus.pickupStarted:
            statusColor = AppTheme.mintGreen;
            statusIcon = LucideIcons.activity;
            break;
          case BookingStatus.completed:
            statusColor = AppTheme.mintGreen;
            statusIcon = LucideIcons.checkCircle;
            break;
          case BookingStatus.cancelled:
            statusColor = Colors.red.shade400;
            statusIcon = LucideIcons.xCircle;
            break;
        }

        final displayId = booking.id.length < 6 
            ? booking.id.toUpperCase() 
            : booking.id.substring(0, 6).toUpperCase();

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () => _showBookingFullDetails(context, booking),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: 32,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? statusColor.withValues(alpha: 0.15) : statusColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          statusIcon,
                          color: isDark ? statusColor : Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#$displayId',
                              style: TextStyle(
                                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.scrapType,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : AppTheme.forestGreen,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: isDark ? 0.2 : 1.0),
                          borderRadius: BorderRadius.circular(16),
                          border: isDark ? Border.all(color: statusColor.withValues(alpha: 0.5)) : null,
                        ),
                        child: Text(
                          booking.status.name.toUpperCase(),
                          style: TextStyle(
                            color: isDark ? statusColor : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: 16,
                        color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${booking.scheduledDate} • ${booking.scheduledSlot}',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 16,
                        color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking.address.addressLine,
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(height: 1, color: isDark ? Colors.white.withValues(alpha: 0.1) : null),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.trendingUp,
                            size: 16,
                            color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            booking.status == BookingStatus.completed
                                ? 'Earned ₹${booking.totalPayoutAmount.toStringAsFixed(0)}'
                                : 'Est. Pay ₹${booking.estimatedPayout.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.forestGreen,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        booking.status == BookingStatus.completed
                            ? '+${booking.pointsEarned} POINTS'
                            : 'Pending Points',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  void _showBookingFullDetails(BuildContext context, Booking booking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayId = booking.id.length < 6 
        ? booking.id.toUpperCase() 
        : booking.id.substring(0, 6).toUpperCase();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade200),
                  ),
                  child: IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking ID',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#$displayId',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : null),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.calendar,
              'Date & Time',
              '${booking.scheduledDate} • ${booking.scheduledSlot}',
              isDark,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.mapPin,
              'Location',
              '${booking.address.label}: ${booking.address.addressLine}',
              isDark,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.user,
              'Assigned Driver',
              booking.assignedPicker != null 
                  ? '${booking.assignedPicker!.name} (${booking.assignedPicker!.vehicleNumber})'
                  : 'Awaiting Driver Assignment',
              isDark,
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : null),
            const SizedBox(height: 16),
            Text(
              booking.status == BookingStatus.completed 
                  ? 'Collected Scrap Quantities' 
                  : 'Estimated Scrap Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : AppTheme.forestGreen,
              ),
            ),
            const SizedBox(height: 16),
            
            if (booking.status == BookingStatus.completed) ...[
              if (booking.actualWeightNewspaper > 0)
                _buildDetailRow(LucideIcons.fileText, 'Newspaper', '${booking.actualWeightNewspaper} kg', isDark),
              if (booking.actualWeightCardboard > 0)
                _buildDetailRow(LucideIcons.package, 'Cardboard', '${booking.actualWeightCardboard} kg', isDark),
              if (booking.actualWeightBooks > 0)
                _buildDetailRow(LucideIcons.bookOpen, 'Books', '${booking.actualWeightBooks} kg', isDark),
              if (booking.actualWeightOfficePaper > 0)
                _buildDetailRow(LucideIcons.fileText, 'Office Paper', '${booking.actualWeightOfficePaper} kg', isDark),
            ] else ...[
              _buildDetailRow(LucideIcons.tag, 'Scrap Type', booking.scrapType, isDark),
              const SizedBox(height: 8),
              _buildDetailRow(LucideIcons.info, 'Estimated Weight', '${booking.estimatedWeight} kg', isDark),
            ],

            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : null),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.status == BookingStatus.completed ? 'Total Payout' : 'Estimated Payout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                Text(
                  booking.status == BookingStatus.completed 
                      ? '₹${booking.totalPayoutAmount.toStringAsFixed(0)}' 
                      : '₹${booking.estimatedPayout.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Eco Points',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mintGreen,
                  ),
                ),
                Text(
                  booking.status == BookingStatus.completed ? '+${booking.pointsEarned}' : 'Pending',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mintGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
