import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/app_state.dart';
import '../../models/booking.dart';

class PickupsHistoryScreen extends StatelessWidget {
  const PickupsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Pickups & History',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final bookings = appState.bookings;

          final completedCount = bookings.where((b) => b.status == BookingStatus.completed).length;
          final upcomingCount = bookings.where((b) => b.status == BookingStatus.pending || b.status == BookingStatus.assigned).length;
          final cancelledCount = bookings.where((b) => b.status == BookingStatus.cancelled).length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    children: [
                      _buildStatCard(
                        context,
                        title: 'Total Bookings',
                        value: '${bookings.length + 12}', // Adding historical ones
                        icon: LucideIcons.package,
                        color: Colors.blue,
                      ),
                      _buildStatCard(
                        context,
                        title: 'Completed',
                        value: '${completedCount + 10}',
                        icon: LucideIcons.checkCircle,
                        color: Colors.green,
                      ),
                      _buildStatCard(
                        context,
                        title: 'Upcoming Active',
                        value: '$upcomingCount',
                        icon: LucideIcons.clock,
                        color: Colors.orange,
                      ),
                      _buildStatCard(
                        context,
                        title: 'Total Earnings',
                        value: '₹${(completedCount * 250) + 2450}',
                        icon: LucideIcons.indianRupee,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'RECENT ACTIVITY',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF0D9488),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (bookings.isEmpty) ...[
                    _buildHistoricalCard(
                      context,
                      scrapType: 'Paper & Cardboard',
                      date: '10 May 2026',
                      weight: '12 kg',
                      earned: '₹180',
                      status: 'Completed',
                    ),
                    const SizedBox(height: 12),
                    _buildHistoricalCard(
                      context,
                      scrapType: 'Plastic Bottles (PET)',
                      date: '03 May 2026',
                      weight: '8 kg',
                      earned: '₹120',
                      status: 'Completed',
                    ),
                    const SizedBox(height: 12),
                    _buildHistoricalCard(
                      context,
                      scrapType: 'Metal & Household Scrap',
                      date: '24 Apr 2026',
                      weight: '24 kg',
                      earned: '₹480',
                      status: 'Completed',
                    ),
                  ] else ...[
                    ...bookings.map((booking) {
                      String statusText = 'Pending';
                      Color statusColor = Colors.orange;

                      if (booking.status == BookingStatus.completed) {
                        statusText = 'Completed';
                        statusColor = Colors.green;
                      } else if (booking.status == BookingStatus.assigned) {
                        statusText = 'Driver Assigned';
                        statusColor = Colors.blue;
                      } else if (booking.status == BookingStatus.cancelled) {
                        statusText = 'Cancelled';
                        statusColor = Colors.red;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D9488).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(LucideIcons.truck, color: Color(0xFF0D9488)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.scrapType,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Est: ${booking.quantityEstimate}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${booking.pickupDate.day}/${booking.pickupDate.month}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalCard(
    BuildContext context, {
    required String scrapType,
    required String date,
    required String weight,
    required String earned,
    required String status,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(LucideIcons.package, color: Color(0xFF0D9488)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scrapType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date  •  $weight',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                earned,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D9488),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
