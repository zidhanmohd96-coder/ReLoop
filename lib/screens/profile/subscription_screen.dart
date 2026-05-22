import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/app_state.dart';
import '../../theme.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = Provider.of<AppState>(context);

    // Dynamic color values based on state to follow newer Flutter specifications (.withValues is custom but since they use .withOpacity in Theme, let's check Theme.dart first or use Color)
    // Wait, the guidelines say: "Constraint: Must use .withValues() instead of .withOpacity() for color transparency (to satisfy newer Flutter analyzer requirements)."
    // Yes! Let's make sure we use .withValues(alpha: 0.x) instead of .withOpacity(0.x).

    final plans = [
      {
        'title': 'Bi-weekly Pickup',
        'price': 59.0,
        'period': '/mo',
        'desc': 'Perfect for standard households.',
        'features': [
          '2 Scheduled Pickups per month',
          'Eco-kit starter bags',
          'Standard scrap pricing + 5% bonus points',
          'SMS tracking alerts'
        ],
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Weekly Pickup',
        'price': 99.0,
        'period': '/mo',
        'desc': 'Best for active recyclers & larger families.',
        'features': [
          '4 Scheduled Pickups per month',
          'Premium eco-bins set',
          'Priority routing (same-day dispatcher)',
          'Standard scrap pricing + 15% bonus points',
          'Exclusive monthly eco-impact report'
        ],
        'color': const Color(0xFF0D9488),
        'popular': true,
      },
      {
        'title': 'Commercial Eco',
        'price': 299.0,
        'period': '/mo',
        'desc': 'Tailored for small offices and local shops.',
        'features': [
          'Unlimited scheduled pickups',
          'Bulk storage cart containers',
          'Custom pricing sheet updates',
          'Standard scrap pricing + 25% bonus points',
          'Dedicated support manager',
          'Corporate social responsibility (CSR) certificate'
        ],
        'color': const Color(0xFF0F766E),
      }
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'ReLoop Premium Plans',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.gem,
                        color: Color(0xFF0D9488),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.isSubscribed ? 'Premium Active' : 'Go Premium',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.forestGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appState.isSubscribed
                                ? 'Active Plan: ${appState.currentSubscriptionPlan}'
                                : 'Subscribe to priority schedules & bonus eco-credits.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Choose a Plan',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.forestGreen,
                ),
              ),
              const SizedBox(height: 16),

              // Render Cards
              ...plans.map((p) {
                final isCurrent = appState.isSubscribed &&
                    appState.currentSubscriptionPlan == p['title'];
                final planColor = p['color'] as Color;

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isCurrent
                          ? planColor
                          : (isDark ? const Color(0xFF334155) : Colors.grey.shade200),
                      width: isCurrent ? 2.5 : 1.0,
                    ),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (p['popular'] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: planColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'POPULAR CHOICE',
                                    style: TextStyle(
                                      color: planColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              Text(
                                p['title'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppTheme.forestGreen,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${(p['price'] as double).toStringAsFixed(0)}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: planColor,
                                ),
                              ),
                              Text(
                                p['period'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p['desc'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      const Divider(height: 32),
                      Column(
                        children: (p['features'] as List<String>).map((feat) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.checkCircle2,
                                  color: planColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    feat,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isCurrent
                              ? () => _showCancelDialog(context, appState)
                              : () => _handleSubscribe(context, appState, p['title'] as String, p['price'] as double, planColor),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCurrent 
                                ? Colors.red.withValues(alpha: 0.1) 
                                : planColor,
                            foregroundColor: isCurrent 
                                ? Colors.red.shade400 
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            side: isCurrent 
                                ? BorderSide(color: Colors.red.shade300, width: 1.5) 
                                : BorderSide.none,
                          ),
                          child: Text(
                            isCurrent ? 'Cancel Subscription' : 'Subscribe Now',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubscribe(
    BuildContext context,
    AppState appState,
    String planName,
    double price,
    Color accentColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
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
              Text(
                'Complete Payment',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.forestGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock priority routing and higher rewards.',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    planName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '₹${price.toStringAsFixed(0)}/mo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentColor),
                  ),
                ],
              ),
              const Divider(height: 32),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    appState.subscribeToPlan(planName, price);
                    Navigator.pop(ctx); // Close sheet
                    Navigator.pop(context); // Go back from subscription screen

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Subscribed to $planName successfully!'),
                        backgroundColor: accentColor,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Pay & Activate',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Subscription?'),
        content: const Text(
          'Are you sure you want to cancel your ReLoop Premium subscription? You will lose bonus points on future collections.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Plan'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.cancelSubscription();
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription cancelled.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
