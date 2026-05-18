import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/app_state.dart';
import '../../models/notification.dart';

class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Notifications',
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
          Consumer<AppState>(
            builder: (context, appState, _) {
              if (appState.unreadNotificationsCount == 0)
                return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  appState.markAllNotificationsAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('All notifications marked as read.'),
                      backgroundColor: const Color(0xFF0D9488),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Mark all read',
                  style: TextStyle(
                    color: Color(0xFF0D9488),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final notifications = appState.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.bellOff,
                      size: 64,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No notifications yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We will notify you about updates, pickup statuses, and green points.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(context, appState, notification);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppState appState,
    AppNotification notification,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color badgeColor;
    IconData icon;

    switch (notification.type) {
      case NotificationType.success:
        badgeColor = Colors.green;
        icon = LucideIcons.checkCircle;
        break;
      case NotificationType.info:
        badgeColor = Colors.blue;
        icon = LucideIcons.info;
        break;
      case NotificationType.warning:
        badgeColor = Colors.amber;
        icon = LucideIcons.alertTriangle;
        break;
      case NotificationType.points:
        badgeColor = const Color(0xFF0D9488);
        icon = LucideIcons.award;
        break;
    }

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          appState.markNotificationAsRead(notification.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? (notification.isRead
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF334155))
              : (notification.isRead ? Colors.white : const Color(0xFFF0FDFA)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? (notification.isRead
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFF0D9488).withOpacity(0.3))
                : (notification.isRead
                      ? Colors.grey[200]!
                      : const Color(0xFF0D9488).withOpacity(0.2)),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: badgeColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${dt.day} ${_getMonthName(dt.month)}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
