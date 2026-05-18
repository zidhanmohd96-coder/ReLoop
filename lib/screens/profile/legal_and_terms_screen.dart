import 'package:flutter/material.dart';

class LegalAndTermsScreen extends StatefulWidget {
  const LegalAndTermsScreen({super.key});

  @override
  State<LegalAndTermsScreen> createState() => _LegalAndTermsScreenState();
}

class _LegalAndTermsScreenState extends State<LegalAndTermsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _sections = [
    {
      'title': '1. Terms of Service',
      'content':
          'By accessing or using the ReLoop application, you agree to comply with and be bound by these Terms of Service. ReLoop provides a digital platform connecting users with local recycling pickup networks. You agree to prepare and sort your materials (plastics, paper, metal, e-waste) into designated bags and clear contaminants (food residue, hazardous chemicals) before the scheduled pickup time. ReLoop reserves the right to reject items that do not meet guidelines.',
    },
    {
      'title': '2. Privacy Policy',
      'content':
          'Your privacy is of utmost importance to us. We collect personal data including your full name, phone number, address, and precise GPS coordinates solely to facilitate pickup logistics. ReLoop does not sell, trade, or share your personal information with external advertising agencies. We secure your transaction and identity details using industry-standard SSL encryption and protected local database clusters.',
    },
    {
      'title': '3. Zero Waste & Carbon Offset Commitment',
      'content':
          'ReLoop is dedicated to a cleaner planet. We pledge that 100% of all accepted recyclable scraps (plastics, aluminum, copper, paper, cardboard) are forwarded to licensed and certified sustainable recycling partners. None of the collected items are redirected to landfills or unsanctioned incinerators. Every pickup contributes to carbon credit metrics updated live in your profile.',
    },
    {
      'title': '4. Pricing & Payout Calculations',
      'content':
          'Green points and digital wallets credits are calculated using precision digital scales operated by our pickup executives at the time of collection. Payout rates for materials vary dynamically based on localized commodity marketplace prices. ReLoop strives to offer fair, transparent, and competitive pricing updated daily in the app\'s price index list.',
    },
    {
      'title': '5. Prohibited & Hazardous Materials',
      'content':
          'Users must not submit bio-medical waste, combustible items, toxic chemicals, radioactive elements, explosives, or any unidentified liquid substances. Attempting to schedule pickups for banned materials may lead to immediate suspension of your account and reporting to local environmental safety authorities if necessary.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredSections = _sections.where((sec) {
      final titleMatch = sec['title']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final contentMatch = sec['content']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return titleMatch || contentMatch;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Legal & Terms',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_rounded,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Terms link copied to clipboard!'),
                  backgroundColor: const Color(0xFF0D9488),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Last Updated Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Last Updated: May 2026',
                        style: TextStyle(
                          color: Color(0xFF0D9488),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'v2.4.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey[200]!,
                    ),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search legal clauses...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF0D9488),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sections List
          Expanded(
            child: filteredSections.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.gavel_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No matching clauses found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredSections.length,
                    itemBuilder: (context, index) {
                      final sec = filteredSections[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey[200]!,
                          ),
                          boxShadow: isDark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sec['title']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D9488),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              sec['content']!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                                height: 1.6,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
