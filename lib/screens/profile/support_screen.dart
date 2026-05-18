import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  final String title;
  final String description;
  final String initialMessage;

  const SupportScreen({
    super.key,
    required this.title,
    required this.description,
    required this.initialMessage,
  });

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchWhatsApp(String message, String phone) async {
    final url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp. Please check if it is installed.')),
      );
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch telephone dialer.')),
      );
    }
  }

  Future<void> _sendEmail(String email, String subject, String body) async {
    final url = Uri.parse("mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client.')),
      );
    }
  }

  void _submitTicket() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your issue first.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isSubmitting = false);
      _messageController.clear();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF0D9488)),
              SizedBox(width: 12),
              Text('Ticket Created!'),
            ],
          ),
          content: const Text(
            'We have received your support request. A support executive will call or text you shortly on your registered number.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('OK', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.title,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner description card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.headphones, color: Color(0xFF0D9488), size: 24),
                        const SizedBox(width: 12),
                        const Text(
                          '24/7 Premium Support Desk',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ONLINE',
                            style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: isDark ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'QUICK CONNECT CHANNEL',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF0D9488),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // WhatsApp Row
              _buildChannelRow(
                context,
                title: 'WhatsApp Chat',
                subtitle: 'Response time: < 3 mins',
                icon: LucideIcons.messageSquare,
                color: Colors.green,
                onTap: () => _launchWhatsApp(widget.initialMessage, '+917736950910'),
              ),
              const SizedBox(height: 12),

              // Phone Row
              _buildChannelRow(
                context,
                title: 'Call Support Helpline',
                subtitle: 'Direct toll-free connect',
                icon: LucideIcons.phone,
                color: Colors.blue,
                onTap: () => _makeCall('+917736950910'),
              ),
              const SizedBox(height: 12),

              // Email Row
              _buildChannelRow(
                context,
                title: 'Email Support Desk',
                subtitle: 'Response within 4 hours',
                icon: LucideIcons.mail,
                color: Colors.purple,
                onTap: () => _sendEmail(
                  'blabpa301@gmail.com',
                  'Support Request: Reloop User Help',
                  'Hi ReLoop Support,\n\nI have an issue with...',
                ),
              ),
              const SizedBox(height: 36),

              Text(
                'SUBMIT A SUPPORT TICKET',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF0D9488),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      style: theme.textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: 'Describe your issue in detail here...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: _isSubmitting ? null : _submitTicket,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Submit Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelRow(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 14),
          ],
        ),
      ),
    );
  }
}
