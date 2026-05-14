part of '../home_screen.dart';

extension RewardsTabExtension on _HomeScreenState {
  Widget _buildRewardsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        Center(
          child: Text(
            'Your Eco Impact',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 32),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'ReLooping since Jan 2024',
            style: TextStyle(
              color: AppTheme.lightGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.forestGreen,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.medal,
                  color: AppTheme.lightGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gold Recycler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'TOP 5% IN KOCHI AREA',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.lightGreen,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NEXT LEVEL: PLATINUM',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const Text(
                    '75%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                LucideIcons.droplets,
                Colors.blue.shade700,
                '850',
                'WATER SAVED',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                LucideIcons.zap,
                Colors.amber.shade700,
                '320',
                'ENERGY SAVED',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                LucideIcons.wind,
                AppTheme.leafGreen,
                '45',
                'CO2 REDUCED',
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(child: SizedBox()), // Empty space
          ],
        ),
        const SizedBox(height: 32),
        Text('Key Milestones', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildMilestoneRow('MAY\n10', '100kg Cardboard Milestone', '+50 pts'),
        const SizedBox(height: 12),
        _buildMilestoneRow('APR\n28', 'First Premium Pickup', '+20 pts'),
        const SizedBox(height: 12),
        _buildMilestoneRow('APR\n15', 'Earth Day Bonus', '+100 pts'),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.leafGreen.withOpacity(0.2),
              foregroundColor: AppTheme.forestGreen,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Generate Sustainability Report >',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    IconData icon,
    Color iconColor,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.forestGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.lightGreen,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneRow(String date, String title, String points) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.lightGreen,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.forestGreen,
              ),
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              color: AppTheme.leafGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
