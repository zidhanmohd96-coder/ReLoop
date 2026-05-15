part of '../home_screen.dart';

extension BookingsTabExtension on _HomeScreenState {
  Widget _buildBookingsTab(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pickups',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.forestGreen,
                    ),
                  ),
                  Text(
                    'YOUR RECYCLING JOURNEY',
                    style: TextStyle(
                      color: AppTheme.lightGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(32),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: AppTheme.forestGreen,
                  borderRadius: BorderRadius.circular(32),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
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
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildBookingCard(
                        'office_paper',
                        'Scheduled',
                        Colors.orange.shade400,
                        'Scheduled for Wed, 14 May',
                        'Home',
                        '₹0',
                        'Pending',
                        LucideIcons.clock,
                        context,
                      ),
                    ],
                  ),
                  // Completed Tab
                  ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildBookingCard(
                        'newspaper, cardboard, books',
                        'Completed',
                        AppTheme.forestGreen,
                        'Completed on Fri, 10 May',
                        'Office',
                        '₹320',
                        '+230 POINTS',
                        LucideIcons.checkCircle,
                        context,
                      ),
                    ],
                  ),
                  // Cancelled Tab
                  ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildBookingCard(
                        'Plastic bottles',
                        'Cancelled',
                        Colors.red.shade400,
                        'Cancelled on Mon, 08 May',
                        'Home',
                        '₹0',
                        '0 POINTS',
                        LucideIcons.xCircle,
                        context,
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

  Widget _buildBookingCard(
    String items,
    String status,
    Color statusColor,
    String schedule,
    String location,
    String earned,
    String points,
    IconData icon,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => _showBookingFullDetails(context),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.getClayDecoration(
          color: Colors.white,
          borderRadius: 32,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.forestGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#QXAU7C',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 120,
                          child: Text(
                            items,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.forestGreen,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(
                  LucideIcons.clock,
                  size: 16,
                  color: AppTheme.lightGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  schedule,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  LucideIcons.mapPin,
                  size: 16,
                  color: AppTheme.lightGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.trendingUp,
                      size: 16,
                      color: AppTheme.lightGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Earned $earned',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.forestGreen,
                      ),
                    ),
                  ],
                ),
                Text(
                  points,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightGreen,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
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
                const Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.forestGreen,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      LucideIcons.x,
                      size: 20,
                      color: AppTheme.forestGreen,
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
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '#QXAU7C',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.forestGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.calendar,
              'Date & Time',
              'Fri, 10 May • 11:30 AM',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.mapPin,
              'Location',
              'Office, 4th Floor, Tech Park',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(LucideIcons.user, 'Collected By', 'Rajesh Kumar'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Scrap Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.forestGreen,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              LucideIcons.fileText,
              'Newspaper',
              '12 kg × ₹15/kg = ₹180',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              LucideIcons.package,
              'Cardboard',
              '14 kg × ₹10/kg = ₹140',
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.forestGreen,
                  ),
                ),
                const Text(
                  '₹320',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: AppTheme.forestGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Eco Points Added',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightGreen,
                  ),
                ),
                const Text(
                  '+230',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightGreen,
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.forestGreen,
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
