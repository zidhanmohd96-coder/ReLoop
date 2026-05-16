part of '../home_screen.dart';

extension ProfileTabExtension on _HomeScreenState {
  Widget _buildProfileTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<AppState>(
      builder: (context, appState, _) => ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.white, width: 4),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.mintGreen, 
                    shape: BoxShape.circle, 
                    border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.white, width: 2)
                  ),
                  child: Icon(LucideIcons.shieldCheck, color: isDark ? const Color(0xFF0F172A) : Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(child: Text('zimu', style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: 28,
          color: isDark ? Colors.white : null,
        ))),
        Center(child: Text('Eco Enthusiast Since 2026', style: TextStyle(
          color: AppTheme.mintGreen, 
          fontWeight: FontWeight.w600
        ))),
        const SizedBox(height: 32),

        _buildSectionHeader('Account', isDark),
        Container(
          decoration: AppTheme.getClayDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white, 
            borderRadius: 24
          ),
          child: Column(children: [
            _buildMenuRow(context, LucideIcons.user, 'Personal Information', isDark, onTap: () => _showPersonalInformationModal(context)),
            _buildMenuRow(context, LucideIcons.mapPin, 'Saved Addresses & Locations', isDark, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressManagementScreen()));
            }),
          ]),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),

        _buildSectionHeader('Information', isDark),
        Container(
          decoration: AppTheme.getClayDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white, 
            borderRadius: 24
          ),
          child: Column(children: [
            _buildMenuRow(context, LucideIcons.package, 'Pickups & History', isDark, onTap: () => _showPickupsHistoryModal(context)),
            _buildMenuRow(context, LucideIcons.tag, 'Scrap Prices', isDark, onTap: () => _showScrapPricesModal(context)),
            _buildMenuRow(context, LucideIcons.ticket, 'Vouchers & Rewards', isDark),
            _buildMenuRow(context, LucideIcons.truck, 'Have bulk scrap?', isDark, onTap: () => _launchWhatsApp('Hi ReLoop, I have bulk scrap for recycling.', '+917736950910')),
            _buildMenuRow(context, LucideIcons.helpCircle, 'FAQ & How it Works', isDark, onTap: () => _showFAQModal(context)),
          ]),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),

        _buildSectionHeader('Contact & Support', isDark),
        Container(
          decoration: AppTheme.getClayDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white, 
            borderRadius: 24
          ),
          child: Column(children: [
            _buildMenuRow(context, LucideIcons.headphones, 'Help & Support', isDark, onTap: () => _showSupportModal(context, 'Help & Support', 'Our support team is available 24/7 to help you with any issues.\n\nCommon issues:\n• Pickup not arriving\n• Payment not received\n• Account related queries\n• App issues', 'I need help with my account.')),
            _buildMenuRow(context, LucideIcons.mail, 'Contact Us', isDark, onTap: () => _showSupportModal(context, 'Contact Us', 'Reach out to us anytime!\n\nEmail: blabpa301@gmail.com\nWhatsApp: +91 7736950910\n\nOffice Hours: Mon-Sat, 9AM-6PM\nAddress: Kochi, Kerala, India', 'Hi ReLoop, I want to contact you.')),
            _buildMenuRow(context, LucideIcons.messageSquare, 'Feedback', isDark, onTap: () => _showFeedbackModal(context)),
            _buildMenuRow(context, LucideIcons.fileText, 'Legal & Terms', isDark),
          ]),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 24),

        _buildSectionHeader('App Settings', isDark),
        Container(
          decoration: AppTheme.getClayDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, borderRadius: 24),
          child: Column(children: [
            // Dark Mode Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(children: [
                Icon(appState.themeMode == ThemeMode.dark ? LucideIcons.moon : LucideIcons.sun,
                  color: appState.themeMode == ThemeMode.dark ? Colors.amber : AppTheme.mintGreen, size: 20),
                const SizedBox(width: 16),
                Expanded(child: Text('Dark Mode', style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppTheme.forestGreen,
                ))),
                Switch.adaptive(
                  value: appState.themeMode == ThemeMode.dark,
                  onChanged: (_) => appState.toggleTheme(),
                  activeColor: AppTheme.mintGreen,
                  activeTrackColor: AppTheme.mintGreen.withOpacity(0.3),
                ),
              ]),
            ),
            _buildMenuRow(context, LucideIcons.bell, 'Notification Preferences', isDark),
            _buildMenuRow(context, LucideIcons.logOut, 'Log Out', isDark, isDestructive: true),
          ]),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
      ],
    ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
      child: Text(title.toUpperCase(), style: TextStyle(
        color: isDark ? Colors.grey.shade600 : Colors.grey.shade500, 
        fontSize: 12, 
        fontWeight: FontWeight.bold, 
        letterSpacing: 1
      )),
    );
  }

  Widget _buildMenuRow(BuildContext context, IconData icon, String title, bool isDark, {bool isDestructive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(children: [
          Icon(icon, color: isDestructive ? Colors.red.shade400 : (isDark ? AppTheme.mintGreen : AppTheme.leafGreen), size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(
            fontWeight: FontWeight.w600, 
            color: isDestructive ? Colors.red.shade400 : (isDark ? Colors.white : AppTheme.forestGreen)
          ))),
          Icon(LucideIcons.chevronRight, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, size: 20),
        ]),
      ),
    );
  }

  Future<void> _launchWhatsApp(String message, String phone) async {
    // Clean phone number: remove non-digits
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}');
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp is not installed on this device'))
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching WhatsApp: $e'))
      );
    }
  }

  void _showSupportModal(BuildContext context, String title, String details, String waMessage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.65,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white, 
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen)),
            IconButton(icon: Icon(LucideIcons.x, color: isDark ? Colors.white : null), onPressed: () => Navigator.pop(ctx)),
          ]),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Text(details, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontSize: 15, height: 1.6)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () { Navigator.pop(ctx); _launchWhatsApp(waMessage, '+917736950910'); },
              icon: const Icon(LucideIcons.messageCircle, size: 18),
              label: const Text('Chat on WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 18), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _showPickupsHistoryModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.6,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white, 
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Pickups & History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen)),
            IconButton(icon: Icon(LucideIcons.x, color: isDark ? Colors.white : null), onPressed: () => Navigator.pop(ctx)),
          ]),
          const SizedBox(height: 24),
          _buildPickupSummaryRow(LucideIcons.package, 'Total Pickups', '12', isDark),
          const SizedBox(height: 12),
          _buildPickupSummaryRow(LucideIcons.checkCircle, 'Completed', '10', isDark),
          const SizedBox(height: 12),
          _buildPickupSummaryRow(LucideIcons.clock, 'Upcoming', '1', isDark),
          const SizedBox(height: 12),
          _buildPickupSummaryRow(LucideIcons.xCircle, 'Cancelled', '1', isDark),
          const SizedBox(height: 12),
          _buildPickupSummaryRow(LucideIcons.indianRupee, 'Total Earned', '₹2,450', isDark),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); setState(() { _currentIndex = 1; _mainPageController.animateToPage(1, duration: const Duration(milliseconds: 600), curve: Curves.easeOutQuint); }); },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen, 
                foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
              child: const Text('View All in Bookings Tab', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildPickupSummaryRow(IconData icon, String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF0F172A) : AppTheme.softBeige, 
        borderRadius: 16
      ),
      child: Row(children: [
        Icon(icon, color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen, size: 20),
        const SizedBox(width: 16),
        Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppTheme.forestGreen))),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen)),
      ]),
    );
  }

  void _showFeedbackModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    int selectedRating = 0;
    final feedbackController = TextEditingController();
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 32, right: 32, top: 32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white, 
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
          ),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Your Feedback', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen)),
              IconButton(icon: Icon(LucideIcons.x, color: isDark ? Colors.white : null), onPressed: () => Navigator.pop(ctx)),
            ]),
            const SizedBox(height: 8),
            Text('Help us improve your experience', style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
            const SizedBox(height: 24),
            Text('Rate your experience', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => GestureDetector(
                onTap: () => setModalState(() => selectedRating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(LucideIcons.star, size: 36, color: i < selectedRating ? Colors.amber : (isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                ),
              )),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: AppTheme.getClayDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white, 
                borderRadius: 20
              ),
              child: TextField(
                controller: feedbackController, maxLines: 4,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Tell us what you think...', 
                  border: InputBorder.none, 
                  contentPadding: const EdgeInsets.all(20), 
                  hintStyle: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade400)
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final msg = 'ReLoop Feedback\nRating: $selectedRating/5\n\n${feedbackController.text}';
                  Navigator.pop(ctx);
                  _launchWhatsApp(msg, '+917736950910');
                },
                icon: const Icon(LucideIcons.send, size: 18),
                label: const Text('Submit Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen, 
                  foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white, 
                  padding: const EdgeInsets.symmetric(vertical: 18), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
              ),
            ),
            const SizedBox(height: 32),
          ])),
        ),
      ),
    );
  }

  void _showScrapPricesModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white, 
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Current Scrap Prices', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen)),
            IconButton(icon: Icon(LucideIcons.x, color: isDark ? Colors.white : null), onPressed: () => Navigator.pop(ctx)),
          ]),
          const SizedBox(height: 24),
          Expanded(child: ListView(children: [
            _buildPriceRow('Newspaper', '₹15/kg', isDark), _buildPriceRow('Cardboard', '₹10/kg', isDark),
            _buildPriceRow('Books', '₹12/kg', isDark), _buildPriceRow('Mixed Paper', '₹8/kg', isDark),
            _buildPriceRow('Iron', '₹28/kg', isDark), _buildPriceRow('Copper', '₹450/kg', isDark),
            _buildPriceRow('Aluminium', '₹110/kg', isDark), _buildPriceRow('E-Waste', '₹20/kg', isDark),
          ])),
        ]),
      ),
    );
  }

  Widget _buildPriceRow(String item, String price, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white, 
        borderRadius: 16
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(item, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : AppTheme.forestGreen)),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.mintGreen)),
      ]),
    );
  }

  void _showFAQModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.8,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white, 
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('FAQ & How it Works', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen)),
            IconButton(icon: Icon(LucideIcons.x, color: isDark ? Colors.white : null), onPressed: () => Navigator.pop(ctx)),
          ]),
          const SizedBox(height: 24),
          Expanded(child: ListView(children: [
            _buildFAQItem('How do I schedule a pickup?', 'Tap "Book Pickup" on the home screen, select your scrap items, choose a date and time, and confirm your location.', isDark),
            _buildFAQItem('What items can I recycle?', 'We accept paper, cardboard, books, plastics, metals (iron, copper, aluminium), and e-waste.', isDark),
            _buildFAQItem('How and when do I get paid?', 'Payment is immediate via UPI or cash once the pickup partner collects and weighs your scrap.', isDark),
            _buildFAQItem('Are there any pickup charges?', 'No, our pickup service is completely free. You get the full value of your scrap.', isDark),
            _buildFAQItem('How do Eco Points work?', 'You earn Eco Points for every pickup. Redeem them for vouchers, discounts, and exclusive rewards.', isDark),
          ])),
        ]),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(20),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF0F172A) : AppTheme.softBeige, 
        borderRadius: 16
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(question, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : AppTheme.forestGreen)),
        const SizedBox(height: 8),
        Text(answer, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, height: 1.5)),
      ]),
    );
  }

  void _showPersonalInformationModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 32, right: 32, top: 32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white, 
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))
        ),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Personal Info', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.forestGreen)),
            IconButton(icon: Icon(LucideIcons.x, color: isDark ? Colors.white : null), onPressed: () => Navigator.pop(ctx)),
          ]),
          const SizedBox(height: 24),
          TextField(
            controller: TextEditingController(text: 'zimu'), 
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Full Name', 
              labelStyle: TextStyle(color: isDark ? Colors.grey.shade500 : null),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen)),
            )
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: '+91 77369 50910'), 
            keyboardType: TextInputType.phone, 
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Phone Number', 
              labelStyle: TextStyle(color: isDark ? Colors.grey.shade500 : null),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen)),
            )
          ),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen, 
              foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
            ),
            child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )),
          const SizedBox(height: 32),
        ])),
      ),
    );
  }
}
