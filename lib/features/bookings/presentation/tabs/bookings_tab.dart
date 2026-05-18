import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import '../../../../providers/app_state.dart';
import '../../../../core/utils/responsive_helper.dart';

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final hPad = context.scalePadding(24.0);

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
                  ListView(
                    padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 120),
                    children: [
                      _buildBookingCard(
                        context: context,
                        items: 'office_paper',
                        status: 'Scheduled',
                        statusColor: Colors.orange.shade400,
                        schedule: 'Scheduled for Wed, 14 May',
                        location: 'Home',
                        earned: '₹0',
                        points: 'Pending',
                        icon: LucideIcons.clock,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  // Completed Tab
                  ListView(
                    padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 120),
                    children: [
                      _buildBookingCard(
                        context: context,
                        items: 'newspaper, cardboard, books',
                        status: 'Completed',
                        statusColor: AppTheme.mintGreen,
                        schedule: 'Completed on Fri, 10 May',
                        location: 'Office',
                        earned: '₹320',
                        points: '+230 POINTS',
                        icon: LucideIcons.checkCircle,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  // Cancelled Tab
                  ListView(
                    padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 120),
                    children: [
                      _buildBookingCard(
                        context: context,
                        items: 'Plastic bottles',
                        status: 'Cancelled',
                        statusColor: Colors.red.shade400,
                        schedule: 'Cancelled on Mon, 08 May',
                        location: 'Home',
                        earned: '₹0',
                        points: '0 POINTS',
                        icon: LucideIcons.xCircle,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required BuildContext context,
    required String items,
    required String status,
    required Color statusColor,
    required String schedule,
    required String location,
    required String earned,
    required String points,
    required IconData icon,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => _showBookingFullDetails(context),
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
                    color: isDark ? AppTheme.mintGreen.withOpacity(0.15) : AppTheme.forestGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: isDark ? AppTheme.mintGreen : Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#QXAU7C',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items,
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
                Flexible(
                  flex: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(isDark ? 0.2 : 1.0),
                      borderRadius: BorderRadius.circular(16),
                      border: isDark ? Border.all(color: statusColor.withOpacity(0.5)) : null,
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: isDark ? statusColor : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  LucideIcons.clock,
                  size: 16,
                  color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    schedule,
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14),
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
                    location,
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(height: 1, color: isDark ? Colors.white.withOpacity(0.1) : null),
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
                      'Earned $earned',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.forestGreen,
                      ),
                    ),
                  ],
                ),
                Text(
                  points,
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
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  void _showBookingFullDetails(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200),
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
                  '#QXAU7C',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.white.withOpacity(0.1) : null),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.calendar,
              'Date & Time',
              'Fri, 10 May • 11:30 AM',
              isDark,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.mapPin,
              'Location',
              'Office, 4th Floor, Tech Park',
              isDark,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(LucideIcons.user, 'Collected By', 'Rajesh Kumar', isDark),
            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.white.withOpacity(0.1) : null),
            const SizedBox(height: 16),
            Text(
              'Scrap Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : AppTheme.forestGreen,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.fileText,
              'Newspaper',
              '12 kg × ₹15/kg = ₹180',
              isDark,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              LucideIcons.package,
              'Cardboard',
              '14 kg × ₹10/kg = ₹140',
              isDark,
            ),
            const SizedBox(height: 16),
            Divider(color: isDark ? Colors.white.withOpacity(0.1) : null),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                Text(
                  '₹320',
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
                  'Eco Points Added',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mintGreen,
                  ),
                ),
                const Text(
                  '+230',
                  style: TextStyle(
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
    return Row(
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
    );
  }
}
