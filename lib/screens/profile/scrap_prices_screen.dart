import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reloop/theme.dart';

class ScrapPricesScreen extends StatefulWidget {
  const ScrapPricesScreen({super.key});

  @override
  State<ScrapPricesScreen> createState() => _ScrapPricesScreenState();
}

class _ScrapPricesScreenState extends State<ScrapPricesScreen> {
  final TextEditingController _weightCtrl = TextEditingController(text: '10');
  String _selectedScrap = 'Copper';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _prices = [
    {'name': 'Newspaper', 'price': 15, 'category': 'Paper', 'trend': 'Stable'},
    {'name': 'Cardboard', 'price': 10, 'category': 'Paper', 'trend': 'Up'},
    {
      'name': 'Books & Magazines',
      'price': 12,
      'category': 'Paper',
      'trend': 'Stable',
    },
    {'name': 'Mixed Paper', 'price': 8, 'category': 'Paper', 'trend': 'Down'},
    {'name': 'Iron', 'price': 28, 'category': 'Metal', 'trend': 'Up'},
    {'name': 'Copper', 'price': 450, 'category': 'Metal', 'trend': 'Up'},
    {'name': 'Aluminium', 'price': 110, 'category': 'Metal', 'trend': 'Stable'},
    {'name': 'Brass', 'price': 320, 'category': 'Metal', 'trend': 'Up'},
    {
      'name': 'PET Bottles',
      'price': 22,
      'category': 'Plastic',
      'trend': 'Stable',
    },
    {
      'name': 'HDPE Plastic',
      'price': 18,
      'category': 'Plastic',
      'trend': 'Down',
    },
    {
      'name': 'E-Waste (Computers)',
      'price': 85,
      'category': 'Electronics',
      'trend': 'Up',
    },
    {
      'name': 'Mobile Phones',
      'price': 150,
      'category': 'Electronics',
      'trend': 'Up',
    },
    {
      'name': 'Lead Batteries',
      'price': 75,
      'category': 'Batteries',
      'trend': 'Stable',
    },
  ];

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  double get _calculatedPayout {
    final weight = double.tryParse(_weightCtrl.text) ?? 0.0;
    final item = _prices.firstWhere(
      (p) => p['name'] == _selectedScrap,
      orElse: () => _prices[0],
    );
    return weight * (item['price'] as int);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredPrices = _prices.where((p) {
      final nameMatch = p['name']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final catMatch = p['category']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return nameMatch || catMatch;
    }).toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Scrap Rates & Index',
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
              // Premium Live Pricing Header banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D9488), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.trendingUp,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Live Scrap Exchange Index',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Rates fluctuate daily based on global commodity markets.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // dynamic interactive calculator
              Text(
                'PAYOUT ESTIMATION CALCULATOR',
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Material',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.grey[50]!,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedScrap,
                                    isExpanded: true,
                                    dropdownColor: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    items: _prices
                                        .map(
                                          (p) => DropdownMenuItem<String>(
                                            value: p['name'] as String,
                                            child: Text(p['name'] as String),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null)
                                        setState(() => _selectedScrap = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Weight (kg)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF0F172A)
                                      : Colors.grey[50]!,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _weightCtrl,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimated Payout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '₹${_calculatedPayout.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF0D9488),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Rates index table
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MATERIAL PRICES INDEX',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF0D9488),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    '${filteredPrices.length} Items',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search material field
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
                    hintText: 'Search material by name or category...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF0D9488),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPrices.length,
                itemBuilder: (context, index) {
                  final item = filteredPrices[index];
                  IconData trendIcon;
                  Color trendColor;

                  if (item['trend'] == 'Up') {
                    trendIcon = LucideIcons.trendingUp;
                    trendColor = Colors.green;
                  } else if (item['trend'] == 'Down') {
                    trendIcon = LucideIcons.trendingDown;
                    trendColor = Colors.red;
                  } else {
                    trendIcon = LucideIcons.minus;
                    trendColor = Colors.grey;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['category'] as String,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${item['price']}/kg',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.forestGreen,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(trendIcon, color: trendColor, size: 16),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
