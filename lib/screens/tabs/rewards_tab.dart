part of '../home_screen.dart';

extension RewardsTabExtension on _HomeScreenState {
  Widget _buildRewardsTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        Center(
          child: Text(
            'Your Eco Impact',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 32,
              color: isDark ? Colors.white : null,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'ReLooping since Jan 2026',
            style: TextStyle(
              color: AppTheme.mintGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ── Current Badge Card ──
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.forestGreen, AppTheme.leafGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppTheme.forestGreen.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.medal, color: Colors.amber, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gold Recycler',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.mintGreen),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NEXT: PLATINUM  •  375/500 pts',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const Text(
                    '75%',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 24),

        // ── Points Balance Card ──
        Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.getClayDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: 28,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.amber.withOpacity(0.1) : Colors.amber.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.coins, color: isDark ? Colors.amber : Colors.amber.shade700, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '450 EcoPoints',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Worth ₹45 in vouchers',
                      style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'History',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 24),

        // ── How Points Work ──
        Text(
          'HOW POINTS WORK',
          style: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildPointInfoCard(LucideIcons.truck, '1 Pickup', '+10 pts', isDark)),
            const SizedBox(width: 12),
            Expanded(child: _buildPointInfoCard(LucideIcons.award, 'Referral', '+50 pts', isDark)),
            const SizedBox(width: 12),
            Expanded(child: _buildPointInfoCard(LucideIcons.star, 'Review', '+5 pts', isDark)),
          ],
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 24),

        // ── Vouchers & Redemption ──
        Text(
          'VOUCHERS & REDEMPTION',
          style: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _buildVoucherCard(
          '₹50 Amazon Voucher',
          '500 pts',
          LucideIcons.shoppingBag,
          Colors.orange,
          false,
          isDark,
        ),
        const SizedBox(height: 12),
        _buildVoucherCard(
          '₹100 Swiggy Voucher',
          '1000 pts',
          LucideIcons.utensils,
          Colors.deepOrange,
          false,
          isDark,
        ),
        const SizedBox(height: 12),
        _buildVoucherCard(
          '₹200 Flipkart Voucher',
          '2000 pts',
          LucideIcons.gift,
          Colors.blue,
          true,
          isDark,
        ),

        const SizedBox(height: 24),

        // ── Eco Stats ──
        Text(
          'YOUR ECO IMPACT',
          style: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(LucideIcons.droplets, Colors.blue.shade400, '850L', 'WATER SAVED', isDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(LucideIcons.zap, Colors.amber.shade400, '320kW', 'ENERGY SAVED', isDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(LucideIcons.wind, AppTheme.mintGreen, '45kg', 'CO2 REDUCED', isDark),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 24),

        // ── All Badges ──
        Text(
          'BADGES & ACHIEVEMENTS',
          style: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _buildBadgeRow(
          LucideIcons.leaf,
          Colors.green,
          'Green Starter',
          'Complete your first pickup',
          true,
          'Unlocks: 10 bonus points',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildBadgeRow(
          LucideIcons.flame,
          Colors.orange,
          'Consistency King',
          '5 pickups in a month',
          true,
          'Unlocks: Priority scheduling',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildBadgeRow(
          LucideIcons.medal,
          Colors.amber,
          'Gold Recycler',
          'Recycle 100kg total',
          true,
          'Unlocks: 2x points multiplier',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildBadgeRow(
          LucideIcons.crown,
          Colors.purple,
          'Platinum Legend',
          'Recycle 500kg total',
          false,
          'Unlocks: Free premium pickups',
          isDark,
        ),
        const SizedBox(height: 12),
        _buildBadgeRow(
          LucideIcons.globe,
          Colors.teal,
          'Earth Guardian',
          'Refer 10 friends',
          false,
          'Unlocks: Exclusive vouchers',
          isDark,
        ),

        const SizedBox(height: 24),

        // ── Key Milestones ──
        Text(
          'RECENT ACTIVITY',
          style: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _buildMilestoneRow('MAY\n10', '100kg Cardboard Milestone', '+50 pts', isDark),
        const SizedBox(height: 12),
        _buildMilestoneRow('APR\n28', 'First Premium Pickup', '+20 pts', isDark),
        const SizedBox(height: 12),
        _buildMilestoneRow('APR\n15', 'Earth Day Bonus', '+100 pts', isDark),

        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppTheme.mintGreen.withOpacity(0.15) : AppTheme.leafGreen.withOpacity(0.1),
              foregroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
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

  Widget _buildPointInfoCard(IconData icon, String title, String pts, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 20,
      ),
      child: Column(
        children: [
          Icon(icon, color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen, size: 22),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppTheme.forestGreen,
          )),
          const SizedBox(height: 4),
          Text(pts, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.mintGreen)),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(String title, String cost, IconData icon, Color color, bool comingSoon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 24,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(16),
              border: isDark ? Border.all(color: color.withOpacity(0.3)) : null,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15,
                  color: isDark ? Colors.white : AppTheme.forestGreen,
                )),
                const SizedBox(height: 2),
                Text(cost, style: TextStyle(color: AppTheme.mintGreen, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: comingSoon 
                ? (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200) 
                : (isDark ? AppTheme.mintGreen : AppTheme.forestGreen),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              comingSoon ? 'Coming Soon' : 'Redeem',
              style: TextStyle(
                color: comingSoon 
                  ? (isDark ? Colors.grey.shade600 : Colors.grey.shade500) 
                  : (isDark ? const Color(0xFF0F172A) : Colors.white),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildStatCard(IconData icon, Color iconColor, String value, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: AppTheme.mintGreen, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeRow(
    IconData icon,
    Color color,
    String title,
    String requirement,
    bool unlocked,
    String benefit,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 24,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked 
                ? color.withOpacity(isDark ? 0.2 : 0.15) 
                : (isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100),
              shape: BoxShape.circle,
              border: unlocked && isDark ? Border.all(color: color.withOpacity(0.3)) : null,
            ),
            child: Icon(
              icon,
              color: unlocked ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: unlocked 
                          ? (isDark ? Colors.white : AppTheme.forestGreen) 
                          : (isDark ? Colors.grey.shade600 : Colors.grey.shade500),
                      ),
                    ),
                    if (unlocked) ...[
                      const SizedBox(width: 8),
                      Icon(LucideIcons.checkCircle, color: AppTheme.mintGreen, size: 16),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  requirement,
                  style: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  benefit,
                  style: TextStyle(
                    color: unlocked ? AppTheme.mintGreen : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildMilestoneRow(String date, String title, String points, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 24,
      ),
      child: Row(
        children: [
          Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.mintGreen,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600, 
                color: isDark ? Colors.white : AppTheme.forestGreen,
              ),
            ),
          ),
          Text(
            points,
            style: const TextStyle(color: AppTheme.mintGreen, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
