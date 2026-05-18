import 'package:flutter/material.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _pickupAlerts = true;
  bool _rewardAlerts = true;
  bool _promoAlerts = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose how you want to be notified about your pickups, rewards, and achievements.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Primary Channels'),
              const SizedBox(height: 12),
              _buildPreferenceCard(
                context,
                title: 'Push Notifications',
                subtitle: 'Receive real-time alerts on your device',
                icon: Icons.notifications_active_rounded,
                iconColor: Colors.blue,
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
              const SizedBox(height: 12),
              _buildPreferenceCard(
                context,
                title: 'SMS Notifications',
                subtitle: 'Get driver arrival alerts via text message',
                icon: Icons.textsms_rounded,
                iconColor: Colors.green,
                value: _smsNotifications,
                onChanged: (val) => setState(() => _smsNotifications = val),
              ),
              const SizedBox(height: 12),
              _buildPreferenceCard(
                context,
                title: 'Email Notifications',
                subtitle: 'Receive monthly eco-reports & receipts',
                icon: Icons.alternate_email_rounded,
                iconColor: Colors.orange,
                value: _emailNotifications,
                onChanged: (val) => setState(() => _emailNotifications = val),
              ),
              const SizedBox(height: 28),
              _buildSectionHeader(context, 'Alert Categories'),
              const SizedBox(height: 12),
              _buildPreferenceCard(
                context,
                title: 'Pickup Status Updates',
                subtitle: 'Scheduled, assigned, and completed alerts',
                icon: Icons.local_shipping_rounded,
                iconColor: Colors.teal,
                value: _pickupAlerts,
                onChanged: (val) => setState(() => _pickupAlerts = val),
              ),
              const SizedBox(height: 12),
              _buildPreferenceCard(
                context,
                title: 'Green Points & Rewards',
                subtitle: 'Milestones, badges, and point updates',
                icon: Icons.emoji_events_rounded,
                iconColor: Colors.amber,
                value: _rewardAlerts,
                onChanged: (val) => setState(() => _rewardAlerts = val),
              ),
              const SizedBox(height: 12),
              _buildPreferenceCard(
                context,
                title: 'Promotions & Tips',
                subtitle: 'Eco-friendly articles and regional offers',
                icon: Icons.eco_rounded,
                iconColor: Colors.lightGreen,
                value: _promoAlerts,
                onChanged: (val) => setState(() => _promoAlerts = val),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: const [
                            Icon(Icons.check_circle_rounded, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Preferences saved successfully!'),
                          ],
                        ),
                        backgroundColor: const Color(0xFF0D9488),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save Preferences',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.bodySmall?.copyWith(
        color: const Color(0xFF0D9488),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildPreferenceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: const Color(0xFF0D9488),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
