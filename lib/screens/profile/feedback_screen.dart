import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _selectedRating = 5;
  String _selectedCategory = 'Service Quality';
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Service Quality',
    'Rates & Pricing',
    'App Bug / Issues',
    'Suggestions',
    'Others',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a short comment first.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isSubmitting = false);
      _feedbackController.clear();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: const [
              Icon(Icons.stars_rounded, color: Color(0xFF0D9488)),
              SizedBox(width: 12),
              Text('Thank You!'),
            ],
          ),
          content: const Text(
            'Your valuable feedback has been submitted successfully. We appreciate your contribution to making ReLoop even better.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFF0D9488),
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          'Share Feedback',
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium banner card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          LucideIcons.heartHandshake,
                          color: Color(0xFF0D9488),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Help Us Improve ReLoop!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your review and constructive ideas play a vital role in our green recycling mission.',
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

              // Interactive Stars
              Center(
                child: Column(
                  children: [
                    Text(
                      'Rate Your Experience',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        final isSelected = starValue <= _selectedRating;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedRating = starValue),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.star_rounded,
                              size: 44,
                              color: isSelected
                                  ? Colors.amber
                                  : Colors.grey[300],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              Text(
                'FEEDBACK CATEGORY',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF0D9488),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal wrap categories
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.grey[350] : Colors.black87),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0D9488),
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : Colors.grey[100]!,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.grey[300]!),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              Text(
                'YOUR DETAILED FEEDBACK',
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
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey[200]!,
                  ),
                ),
                child: TextField(
                  controller: _feedbackController,
                  maxLines: 5,
                  style: theme.textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    hintText:
                        'Share what you like, what is missing, or how we can improve our service...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 48),

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
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Submit Feedback',
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
}
