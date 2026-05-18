import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _searchQuery = '';
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I prepare my scrap for pickup?',
      'answer':
          'Please segregate your recyclable materials into plastic bottles, papers/cardboards, metals, and electronics. Rinse out any food containers to avoid odors and contamination. You don\'t need to label them—our pickup executive will verify everything at your doorstep.',
    },
    {
      'question': 'How are green points and payments calculated?',
      'answer':
          'At pickup, our executive weighs your materials using a certified high-precision digital scale. Payout rates are calculated based on the day\'s rate index. You can choose to receive direct digital cash or earn sustainability green points to redeem premium coupons.',
    },
    {
      'question': 'What items are strictly prohibited?',
      'answer':
          'We cannot accept household wet garbage, medical waste, hazardous chemicals, batteries with fluid leaks, radioactive materials, weapons, ammunition, or organic compost.',
    },
    {
      'question': 'Is there a minimum weight requirement for pickups?',
      'answer':
          'Yes, the minimum required weight is 5 kg in aggregate across all categories. This helps us minimize transport carbon emissions and coordinate collection routes efficiently.',
    },
    {
      'question': 'How can I refer a friend and earn rewards?',
      'answer':
          'Go to the home tab or profile tab, share your unique referral code. Once your referred friend completes their first pickup of at least 5 kg, 500 bonus green points will be added to your account instantly!',
    },
    {
      'question': 'In which cities is ReLoop service active?',
      'answer':
          'We are currently operating active routes throughout Kochi, Trivandrum, Kozhikode, and Thrissur. We are actively expanding to new cities weekly.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredFaqs = _faqs.where((faq) {
      final qMatch = faq['question']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final aMatch = faq['answer']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return qMatch || aMatch;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'FAQ & Help Center',
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
      ),
      body: Column(
        children: [
          // FAQ Header Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.helpCircle,
                          color: Color(0xFF0D9488),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'How can we help you?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Find quick answers below or contact our 24/7 support line.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search Box
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey[200]!,
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search popular topics...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF0D9488),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // FAQ Expansion ListView
          Expanded(
            child: filteredFaqs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.helpCircle,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No answers found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: filteredFaqs.length,
                    itemBuilder: (context, index) {
                      final faq = filteredFaqs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            iconColor: const Color(0xFF0D9488),
                            collapsedIconColor: Colors.grey,
                            title: Text(
                              faq['question']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 20,
                                ),
                                child: Text(
                                  faq['answer']!,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    height: 1.5,
                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
