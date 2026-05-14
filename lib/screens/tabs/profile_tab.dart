part of '../home_screen.dart';

extension ProfileTabExtension on _HomeScreenState {
  Widget _buildProfileTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.leafGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    LucideIcons.shieldCheck,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'zimu',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 28),
          ),
        ),
        Center(
          child: Text(
            'Eco Enthusiast Since 2026',
            style: TextStyle(
              color: AppTheme.lightGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 32),
        // 1. Account Section
        _buildSectionHeader('Account'),
        Container(
          decoration: AppTheme.getClayDecoration(
            color: Colors.white,
            borderRadius: 24,
          ),
          child: Column(
            children: [
              _buildMenuRow(
                context,
                LucideIcons.user,
                'Personal Information',
                onTap: () => _showPersonalInformationModal(context),
              ),
              _buildMenuRow(
                context,
                LucideIcons.mapPin,
                'Saved Addresses & Locations',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddressManagementScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),

        // 2. Information Section
        _buildSectionHeader('Information'),
        Container(
          decoration: AppTheme.getClayDecoration(
            color: Colors.white,
            borderRadius: 24,
          ),
          child: Column(
            children: [
              _buildMenuRow(context, LucideIcons.package, 'Pickups & History'),
              _buildMenuRow(
                context,
                LucideIcons.tag,
                'Scrap Prices',
                onTap: () => _showScrapPricesModal(context),
              ),
              _buildMenuRow(context, LucideIcons.ticket, 'Vouchers & Rewards'),
              _buildMenuRow(
                context,
                LucideIcons.truck,
                'Have bulk scrap?',
                onTap: () => _launchWhatsApp(
                  'Hi ReLoop, I have bulk scrap for recycling.',
                ),
              ),
              _buildMenuRow(
                context,
                LucideIcons.helpCircle,
                'FAQ & How it Works',
                onTap: () => _showFAQModal(context),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),

        // 3. Contact Section
        _buildSectionHeader('Contact & Support'),
        Container(
          decoration: AppTheme.getClayDecoration(
            color: Colors.white,
            borderRadius: 24,
          ),
          child: Column(
            children: [
              _buildMenuRow(
                context,
                LucideIcons.headphones,
                'Help & Support',
                onTap: () => _launchWhatsApp('I need help with my account.'),
              ),
              _buildMenuRow(
                context,
                LucideIcons.mail,
                'Contact Us',
                onTap: () => _launchWhatsApp('Hi ReLoop, I want to contact you.'),
              ),
              _buildMenuRow(
                context,
                LucideIcons.messageSquare,
                'Feedback',
                onTap: () => _launchWhatsApp('I want to provide some feedback.'),
              ),
              _buildMenuRow(context, LucideIcons.fileText, 'Legal & Terms'),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),

        // 4. App Settings
        _buildSectionHeader('App Settings'),
        Container(
          decoration: AppTheme.getClayDecoration(
            color: Colors.white,
            borderRadius: 24,
          ),
          child: Column(
            children: [
              _buildMenuRow(
                context,
                LucideIcons.bell,
                'Notification Preferences',
              ),
              _buildMenuRow(
                context,
                LucideIcons.logOut,
                'Log Out',
                isDestructive: true,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildMenuRow(
    BuildContext context,
    IconData icon,
    String title, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red.shade400 : AppTheme.leafGreen,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? Colors.red.shade400 : AppTheme.forestGreen,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: Colors.grey.shade300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchWhatsApp(String message) async {
    final url = Uri.parse(
      'whatsapp://send?phone=+919876543210&text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  void _showScrapPricesModal(BuildContext context) {
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Scrap Prices',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.forestGreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildPriceRow('Newspaper', '₹15/kg'),
                  _buildPriceRow('Cardboard', '₹10/kg'),
                  _buildPriceRow('Books', '₹12/kg'),
                  _buildPriceRow('Mixed Paper', '₹8/kg'),
                  _buildPriceRow('Iron', '₹28/kg'),
                  _buildPriceRow('Copper', '₹450/kg'),
                  _buildPriceRow('Aluminium', '₹110/kg'),
                  _buildPriceRow('E-Waste', '₹20/kg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String item, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.getClayDecoration(
        color: Colors.white,
        borderRadius: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.forestGreen,
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.lightGreen,
            ),
          ),
        ],
      ),
    );
  }

  void _showFAQModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FAQ & How it Works',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.forestGreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildFAQItem(
                    'How do I schedule a pickup?',
                    'Simply tap the "Book Pickup" button on the home screen, select your scrap items, choose a date and time, and confirm your location.',
                  ),
                  _buildFAQItem(
                    'What items can I recycle?',
                    'We accept all types of paper, cardboard, books, plastics, metals (iron, copper, aluminium), and e-waste. Check the Scrap Prices section for a detailed list.',
                  ),
                  _buildFAQItem(
                    'How and when do I get paid?',
                    'You will receive the payment immediately via UPI or cash as soon as the pickup partner collects and weighs your scrap.',
                  ),
                  _buildFAQItem(
                    'Are there any pickup charges?',
                    'No, our pickup service is completely free of charge. You get the full value of your scrap based on the current rates.',
                  ),
                  _buildFAQItem(
                    'How do Eco Points work?',
                    'You earn Eco Points for every successful pickup. These points can be redeemed for vouchers, discounts, and exclusive rewards in the Vouchers section.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.getClayDecoration(
        color: AppTheme.softBeige,
        borderRadius: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppTheme.forestGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _showPersonalInformationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 32,
          right: 32,
          top: 32,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Personal Info',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.forestGreen,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: TextEditingController(text: 'zimu'),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: '+91 98765 43210'),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.forestGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
