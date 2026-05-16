part of '../home_screen.dart';

extension HomeTabExtension on _HomeScreenState {
  Widget _buildHomeTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: AppTheme.getClayDecoration(
                    color: AppTheme.forestGreen,
                  ),
                  child: const Icon(
                    LucideIcons.treeDeciduous,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ReLoop',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.forestGreen,
                      ),
                    ),
                    Text(
                      'PREMIUM RECYCLING',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.lightGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'OFFERS & NEWS',
          style: TextStyle(
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _offersPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentOfferIndex = index % _offers.length;
                  });
                },
                itemBuilder: (context, i) {
                  final index = i % _offers.length;
                  final offer = _offers[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: offer['color'],
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Text(
                              offer['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              offer['desc'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  offer['icon'],
                                                  color: offer['iconColor'],
                                                  size: 32,
                                                ),
                                                const SizedBox(width: 16),
                                                Text(
                                                  offer['modalTitle'],
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.forestGreen,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  LucideIcons.x,
                                                  size: 20,
                                                  color: AppTheme.forestGreen,
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 32),
                                        Text(
                                          'DETAILS & REQUIREMENTS',
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          offer['modalDesc'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.forestGreen,
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BookingFlowScreen(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppTheme.forestGreen,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: const Text(
                                              'Schedule Now',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('LEARN MORE'),
                            ),
                          ],
                        ),
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            offer['icon'],
                            size: 100,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        const SizedBox(height: 24),
        Text(
          'SCHEDULED PICK-UP',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
              onTap: () => _showPickupDetails(context),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.getClayDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.mintGreen.withOpacity(0.15)
                                : AppTheme.leafGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            LucideIcons.truck,
                            color: isDark
                                ? AppTheme.mintGreen
                                : AppTheme.forestGreen,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcoming Pickup',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white
                                      : AppTheme.forestGreen,
                                ),
                              ),
                              Text(
                                'EST. WEIGHT: 15-20 KG',
                                style: TextStyle(
                                  color: isDark
                                      ? AppTheme.mintGreen
                                      : AppTheme.lightGreen,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: isDark
                                ? Border.all(
                                    color: Colors.orange.withOpacity(0.3),
                                  )
                                : null,
                          ),
                          child: Text(
                            'PENDING',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.orange.shade400
                                  : Colors.orange.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.calendar,
                                    size: 14,
                                    color: isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Wed, 20 May',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.mapPin,
                                    size: 14,
                                    color: isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Home, Kochi',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.4,
                        backgroundColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 100.ms, duration: 500.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),

        const SizedBox(height: 32),
        Text(
          'QUICK START',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
        const SizedBox(height: 16),
        if (_isServiceAvailable)
          InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingFlowScreen(),
                    ),
                  );
                },
                child:
                    Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 32,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.forestGreen, Color(0xFF1E5631)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.forestGreen.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'Book Pickup',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        LucideIcons.arrowRight,
                                        color: AppTheme.leafGreen,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Schedule in seconds',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .shimmer(duration: 2000.ms, color: Colors.white24),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad)
        else
          GestureDetector(
                onTap: () => _showServiceZonesModal(context),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.getClayDecoration(
                    color: Colors.white,
                    borderRadius: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.alertTriangle,
                            color: Colors.orange.shade400,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Service Unavailable',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We are currently expanding. Tap to view our active service zones in Kerala.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Kerala zone chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildZoneChip('Kochi', true),
                          _buildZoneChip('Thrissur', true),
                          _buildZoneChip('Calicut', false),
                          _buildZoneChip('Trivandrum', false),
                          _buildZoneChip('Kannur', false),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.leafGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Coming Soon',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),

        const SizedBox(height: 16),
        Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: AppTheme.getClayDecoration(
                color: Colors.white,
                borderRadius: 24,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.leafGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.mapPin,
                      size: 16,
                      color: AppTheme.forestGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '123 Green Valley Road, Eco Park, City Center',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.forestGreen,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isServiceAvailable = !_isServiceAvailable;
                      });
                    },
                    child: Text(
                      'CHANGE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightGreen,
                      ),
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 500.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
                  child: GestureDetector(
                    onTap: () => _showPointsHistory(context),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: AppTheme.getClayDecoration(
                        color: AppTheme.forestGreen,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.zap,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            '450',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'ECOPOINTS',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 500.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(width: 16),
            Expanded(
                  child: GestureDetector(
                    onTap: () => _showAppInfo(context),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: AppTheme.getClayDecoration(
                        color: AppTheme.forestGreen,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.info,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'What is\nReLoop?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 500.ms, duration: 500.ms)
                .slideY(begin: 0.1, end: 0),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRICING (₹/KG)',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              'DAILY RATES',
              style: TextStyle(
                color: AppTheme.lightGreen,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildPricingCard(
                context,
                'Paper',
                '₹17',
                LucideIcons.bookOpen,
                'Includes old newspapers, magazines, and notebooks. Please ensure they are dry and not contaminated with food waste.',
              ),
              const SizedBox(width: 16),
              _buildPricingCard(
                context,
                'Cardboard',
                '₹10',
                LucideIcons.package,
                'Shipping boxes, packaging, and brown paper. Please flatten the boxes to save space.',
              ),
              const SizedBox(width: 16),
              _buildPricingCard(
                context,
                'Books',
                '₹16',
                LucideIcons.library,
                'Old textbooks, novels, and hardbounds. Heavily damaged or missing covers are also accepted.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'CUSTOMER REVIEWS',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildReviewCard(
                'Salman Nazeer.',
                'Very professional and on time. Highly recommended!',
                5,
              ),
              const SizedBox(width: 16),
              _buildReviewCard(
                'Sadiq.',
                'Great app to recycle old newspapers. Got my eco points instantly.',
                5,
              ),
              const SizedBox(width: 16),
              _buildReviewCard(
                'Sulaiman.',
                'The picker was polite and the whole process was smooth.',
                4,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        // Referral Banner
        const SizedBox(height: 32),
        Text(
          'REFER & EARN',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF0FDF4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite & Earn',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : AppTheme.forestGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Get 500 Eco Points for every friend you refer.',
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? AppTheme.mintGreen
                                : AppTheme.forestGreen,
                            foregroundColor: isDark
                                ? const Color(0xFF0F172A)
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'SHARE CODE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppTheme.mintGreen
                                      : AppTheme.forestGreen)
                                  .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.gift,
                          size: 40,
                          color: isDark
                              ? AppTheme.mintGreen
                              : AppTheme.forestGreen,
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(duration: 2.seconds, curve: Curves.easeInOut),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: 800.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
      ],
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    String name,
    String price,
    IconData icon,
    String details,
  ) {
    return GestureDetector(
      onTap: () => _showPricingDetails(context, name, price, icon, details),
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.getClayDecoration(
          color: Colors.white,
          borderRadius: 32,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                LucideIcons.info,
                size: 14,
                color: Colors.grey.shade300,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 32, color: AppTheme.forestGreen),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppTheme.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      color: AppTheme.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPricingDetails(
    BuildContext context,
    String name,
    String price,
    IconData icon,
    String details,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48, color: AppTheme.forestGreen),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.forestGreen,
                          ),
                        ),
                        Text(
                          '$price per KG',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
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
            const SizedBox(height: 32),
            Text(
              'DETAILS & REQUIREMENTS',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              details,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingFlowScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.forestGreen,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Schedule Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPointsHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Points History',
                  style: TextStyle(
                    fontSize: 28,
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
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryRow(
                    'Paper Recycling',
                    '+150 pts',
                    '12 May 2026',
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  _buildHistoryRow(
                    'Cardboard Bulk',
                    '+200 pts',
                    '05 May 2026',
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  _buildHistoryRow(
                    'Referral Bonus',
                    '+100 pts',
                    '01 May 2026',
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryRow(String title, String points, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.forestGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          Text(
            points,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightGreen,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'What is ReLoop?',
                  style: TextStyle(
                    fontSize: 28,
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
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'ReLoop is a modern sustainability and recycling platform designed to make recycling easy, rewarding, and transparent.\n\nWe connect households and businesses with reliable pickup staff, ensuring your scrap materials (like paper and cardboard) are ethically recycled.\n\nOur mission is to build a greener future while rewarding our community with ECOPOINTS for every contribution.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPickupDetails(BuildContext context) {
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
                  'Pickup Details',
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
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: AppTheme.softBeige,
                borderRadius: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.clock,
                        size: 20,
                        color: AppTheme.forestGreen,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Wed, 14 May • 10:00 AM - 1:00 PM',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.forestGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.mapPin,
                        size: 20,
                        color: AppTheme.forestGreen,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '123 Green Valley Road, Eco Park, City Center',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.forestGreen,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: Colors.white,
                borderRadius: 24,
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.leafGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.user,
                      color: AppTheme.forestGreen,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rajesh Kumar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.forestGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Assigned Picker',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.phone, size: 18),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.forestGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      LucideIcons.messageCircle,
                      size: 18,
                      color: AppTheme.forestGreen,
                    ),
                    label: const Text(
                      'WhatsApp',
                      style: TextStyle(color: AppTheme.forestGreen),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightGreen.withOpacity(0.1),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showCancelPickup(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Cancel Pickup',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCancelPickup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          top: 32,
          left: 32,
          right: 32,
        ),
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
            const Text(
              'Cancel Pickup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please let us know why you are canceling this pickup.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Reason for cancellation',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: AppTheme.forestGreen,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        // Mark as cancelled, e.g. updating a state variable
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pickup cancelled successfully.'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirm Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, String review, int rating) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.getClayDecoration(
        color: Colors.white,
        borderRadius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.forestGreen,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? LucideIcons.star : LucideIcons.starHalf,
                    size: 16,
                    color: index < rating ? Colors.amber : Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              '"$review"',
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneChip(String name, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.leafGreen.withOpacity(0.15)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppTheme.leafGreen.withOpacity(0.4)
              : Colors.grey.shade300,
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive ? AppTheme.forestGreen : Colors.grey.shade500,
        ),
      ),
    );
  }

  void _showServiceZonesModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Zones',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    LucideIcons.x,
                    color: isDark ? Colors.grey.shade400 : null,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'KERALA, INDIA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Kerala Map — vertical strip layout matching actual geography
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [const Color(0xFFE0F2FE), const Color(0xFFF0FDF4)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : Colors.grey.shade200,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    // Kerala cities positioned N→S along a slightly curved vertical strip
                    // Kannur (north), Calicut, Thrissur, Kochi, Trivandrum (south)
                    final zones = [
                      {'name': 'Kannur', 'active': false, 'x': 0.55, 'y': 0.10},
                      {
                        'name': 'Calicut',
                        'active': false,
                        'x': 0.40,
                        'y': 0.26,
                      },
                      {
                        'name': 'Thrissur',
                        'active': true,
                        'x': 0.48,
                        'y': 0.44,
                      },
                      {'name': 'Kochi', 'active': true, 'x': 0.55, 'y': 0.58},
                      {
                        'name': 'Trivandrum',
                        'active': false,
                        'x': 0.45,
                        'y': 0.85,
                      },
                    ];

                    return Stack(
                      children: [
                        // Kerala outline shape (simplified CustomPaint)
                        CustomPaint(
                          size: Size(w, h),
                          painter: _KeralaOutlinePainter(isDark: isDark),
                        ),
                        // Zone markers
                        ...zones.map((z) {
                          final isActive = z['active'] as bool;
                          final name = z['name'] as String;
                          final px = (z['x'] as double) * w;
                          final py = (z['y'] as double) * h;
                          return Positioned(
                            left: px - 30,
                            top: py - 10,
                            child: _buildMapZoneMarker(name, isActive),
                          );
                        }),
                        // Watermark label
                        Positioned(
                          bottom: 12,
                          right: 16,
                          child: Text(
                            'ReLoop Coverage',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Zone list
            _buildZoneListItem('Kochi', 'Fully operational', true, isDark),
            const SizedBox(height: 6),
            _buildZoneListItem('Thrissur', 'Fully operational', true, isDark),
            const SizedBox(height: 6),
            _buildZoneListItem('Calicut', 'Launching Q3 2026', false, isDark),
            const SizedBox(height: 6),
            _buildZoneListItem(
              'Trivandrum',
              'Launching Q4 2026',
              false,
              isDark,
            ),
            const SizedBox(height: 6),
            _buildZoneListItem('Kannur', 'Launching Q1 2027', false, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildMapZoneMarker(String name, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.mintGreen : Colors.grey.shade400,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.mintGreen.withOpacity(0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: const Icon(LucideIcons.mapPin, size: 14, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.forestGreen.withOpacity(0.8)
                : Colors.grey.shade600.withOpacity(0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZoneListItem(
    String zone,
    String status,
    bool isActive,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark
                  ? AppTheme.mintGreen.withOpacity(0.12)
                  : AppTheme.leafGreen.withOpacity(0.08))
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? (isDark
                    ? AppTheme.mintGreen.withOpacity(0.3)
                    : AppTheme.leafGreen.withOpacity(0.1))
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.mintGreen : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            zone,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? (isDark ? Colors.white : AppTheme.forestGreen)
                  : Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppTheme.mintGreen : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeralaOutlinePainter extends CustomPainter {
  final bool isDark;
  _KeralaOutlinePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // A very simplified representation of Kerala's vertical, slightly curved shape
    path.moveTo(w * 0.45, h * 0.05);
    path.quadraticBezierTo(w * 0.35, h * 0.25, w * 0.40, h * 0.45);
    path.quadraticBezierTo(w * 0.55, h * 0.65, w * 0.45, h * 0.95);
    path.lineTo(w * 0.65, h * 0.90);
    path.quadraticBezierTo(w * 0.75, h * 0.60, w * 0.60, h * 0.35);
    path.quadraticBezierTo(w * 0.55, h * 0.15, w * 0.60, h * 0.05);
    path.close();

    canvas.drawPath(path, paint);

    final strokePaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
