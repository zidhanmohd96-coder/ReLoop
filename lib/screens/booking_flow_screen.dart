import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../models/booking.dart';
import '../providers/app_state.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import 'address_management_screen.dart';
import 'booking_confirmed_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  int _currentStep = 0;
  final int _totalSteps = 5;
  final List<String> _selectedScrapTypes = [];
  String? _selectedQuantity;

  DateTime? _selectedDate;
  DateTime _calendarMonth = DateTime.now();

  final _contactNameController = TextEditingController(text: 'zimu');
  final _contactNumberController = TextEditingController();
  final _instructionsController = TextEditingController();

  // Pricing per kg for each scrap type
  static const Map<String, double> _scrapPrices = {
    'Newspaper': 17,
    'Cardboard': 10,
    'Office Paper': 14,
    'Books': 16,
  };

  // Estimated weight ranges per quantity
  static const Map<String, List<double>> _quantityRanges = {
    'Small (<5kg)': [2, 5],
    'Medium (5-20kg)': [5, 20],
    'Large (20kg+)': [20, 50],
  };

  final List<Map<String, dynamic>> _scrapTypes = [
    {'title': 'Newspaper', 'icon': LucideIcons.bookOpen},
    {'title': 'Cardboard', 'icon': LucideIcons.package},
    {'title': 'Office Paper', 'icon': LucideIcons.fileText},
    {'title': 'Books', 'icon': LucideIcons.library},
  ];

  final List<String> _quantities = [
    'Small (<5kg)',
    'Medium (5-20kg)',
    'Large (20kg+)',
  ];

  // Service availability by day-of-week (0=Mon..6=Sun). Sunday unavailable.
  bool _isDateAvailable(DateTime d) {
    if (d.isBefore(DateTime.now().subtract(const Duration(days: 1)))) return false;
    if (d.weekday == DateTime.sunday) return false;
    return true;
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactNumberController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submitBooking() {
    final appState = Provider.of<AppState>(context, listen: false);
    final defaultAddress = appState.addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => appState.addresses.first,
    );

    final booking = Booking(
      scrapType: _selectedScrapTypes.isEmpty
          ? 'Mixed'
          : _selectedScrapTypes.join(', '),
      quantityEstimate: _selectedQuantity ?? 'Small',
      pickupDate: DateTime.now().add(const Duration(days: 1)),
      pickupTimeSlot: '10:00 AM - 01:00 PM',
      address: defaultAddress,
      contactName: _contactNameController.text,
      contactNumber: _contactNumberController.text.isEmpty
          ? '9876543210'
          : _contactNumberController.text,
      instructions: _instructionsController.text,
    );

    appState.addBooking(booking);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BookingConfirmedScreen()),
    );
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedScrapTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one scrap type')),
      );
      return;
    }
    if (_currentStep == 1 && _selectedQuantity == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a quantity')));
      return;
    }
    if (_currentStep == 2 && _selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a pickup date')));
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitBooking();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Type';
      case 1:
        return 'Quantity';
      case 2:
        return 'Schedule';
      case 3:
        return 'Address';
      case 4:
        return 'Contact';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF0FDF4),
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'STEP ${_currentStep + 1} OF $_totalSteps',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              _getStepTitle(),
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.forestGreen,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                LucideIcons.chevronLeft,
                color: isDark ? Colors.white : AppTheme.forestGreen,
                size: 20,
              ),
              onPressed: _prevStep,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkBgGradient : AppTheme.lightBgGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                  children: [
                    if (_currentStep == 0)
                      _buildScrapTypeStep()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                    if (_currentStep == 1)
                      _buildQuantityStep()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                    if (_currentStep == 2)
                      _buildScheduleStep()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                    if (_currentStep == 3)
                      _buildAddressStep()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                    if (_currentStep == 4)
                      _buildContactStep()
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: _buildBottomActionBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _prevStep,
              icon: Icon(
                LucideIcons.chevronLeft,
                color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == 4 ? 'Book Now' : 'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.chevronRight,
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrapTypeStep() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are we\nrecycling?',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(
            fontSize: 48,
            height: 1.1,
            color: isDark ? Colors.white : AppTheme.forestGreen,
          ),
        ),
        const SizedBox(height: 48),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: _scrapTypes.length,
          itemBuilder: (context, index) {
            final type = _scrapTypes[index];
            final isSelected = _selectedScrapTypes.contains(type['title']);
            return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedScrapTypes.remove(type['title']);
                      } else {
                        _selectedScrapTypes.add(type['title']);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isDark
                          ? (isSelected ? const Color(0xFF1E293B) : const Color(0xFF0F172A))
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? AppTheme.mintGreen : AppTheme.forestGreen)
                            : (isDark ? const Color(0xFF334155) : Colors.transparent),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        if (!isSelected && !isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type['icon'],
                          size: 40,
                          color: isSelected
                              ? (isDark ? AppTheme.mintGreen : AppTheme.forestGreen)
                              : (isDark ? Colors.grey.shade400 : AppTheme.forestGreen),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          type['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? (isDark ? AppTheme.mintGreen : AppTheme.forestGreen)
                                : (isDark ? Colors.grey.shade400 : AppTheme.forestGreen),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate(delay: (index * 100).ms)
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.1, end: 0);
          },
        ),
      ],
    );
  }

  Widget _buildQuantityStep() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimate\nQuantity',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 48, height: 1.1,
            color: isDark ? Colors.white : null,
          ),
        ),
        const SizedBox(height: 32),
        ..._quantities.map((q) {
          final isSelected = _selectedQuantity == q;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedQuantity = q),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppTheme.leafGreen.withOpacity(0.2) : AppTheme.leafGreen.withOpacity(0.1))
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  border: Border.all(
                    color: isSelected ? AppTheme.mintGreen : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.scale, color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(q, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppTheme.forestGreen, fontSize: 18)),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: AppTheme.mintGreen, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.check, color: Colors.white, size: 16),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        // ── Estimated Earnings Card ──
        if (_selectedQuantity != null && _selectedScrapTypes.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildEstimatedEarnings(isDark),
        ],
      ],
    );
  }

  Widget _buildEstimatedEarnings(bool isDark) {
    final range = _quantityRanges[_selectedQuantity]!;
    final avgKg = (range[0] + range[1]) / 2;
    final perTypeKg = avgKg / _selectedScrapTypes.length;

    double totalMin = 0, totalMax = 0;
    for (final t in _selectedScrapTypes) {
      final price = _scrapPrices[t] ?? 12;
      totalMin += range[0] / _selectedScrapTypes.length * price;
      totalMax += range[1] / _selectedScrapTypes.length * price;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
            : [const Color(0xFFF0FDF4), const Color(0xFFD1FAE5)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.mintGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.indianRupee, color: AppTheme.accentAmber, size: 20),
              const SizedBox(width: 8),
              Text('ESTIMATED EARNINGS', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1,
                color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
              )),
            ],
          ),
          const SizedBox(height: 16),
          ..._selectedScrapTypes.map((t) {
            final price = _scrapPrices[t] ?? 12;
            final minE = (range[0] / _selectedScrapTypes.length * price).round();
            final maxE = (range[1] / _selectedScrapTypes.length * price).round();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t, style: TextStyle(color: isDark ? Colors.white70 : AppTheme.forestGreen, fontWeight: FontWeight.w500)),
                  Text('₹$minE – ₹$maxE', style: TextStyle(color: isDark ? AppTheme.paleGreen : AppTheme.lightGreen, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : AppTheme.forestGreen)),
              Text('₹${totalMin.round()} – ₹${totalMax.round()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.accentAmber)),
            ],
          ),
          const SizedBox(height: 8),
          Text('+ Bonus EcoPoints on every pickup!', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade500 : Colors.grey.shade600, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildScheduleStep() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final firstOfMonth = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    final daysInMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday; // 1=Mon
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick a\nDate',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 48, height: 1.1,
            color: isDark ? Colors.white : null,
          ),
        ),
        const SizedBox(height: 24),
        // Calendar card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: 16, offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Month nav
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(LucideIcons.chevronLeft, color: isDark ? Colors.white70 : AppTheme.forestGreen, size: 20),
                    onPressed: () {
                      setState(() {
                        _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month - 1);
                      });
                    },
                  ),
                  Text(
                    '${months[_calendarMonth.month - 1]} ${_calendarMonth.year}',
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                  ),
                  IconButton(
                    icon: Icon(LucideIcons.chevronRight, color: isDark ? Colors.white70 : AppTheme.forestGreen, size: 20),
                    onPressed: () {
                      setState(() {
                        _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Day headers
              Row(
                children: dayLabels.map((d) => Expanded(
                  child: Center(
                    child: Text(d, style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold,
                      color: d == 'Sun'
                        ? (isDark ? Colors.red.shade300 : Colors.red.shade400)
                        : (isDark ? Colors.grey.shade500 : Colors.grey.shade500),
                      letterSpacing: 0.5,
                    )),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 8),
              // Day grid
              ...List.generate(6, (week) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: List.generate(7, (col) {
                      final dayNum = week * 7 + col + 1 - (startWeekday - 1);
                      if (dayNum < 1 || dayNum > daysInMonth) {
                        return const Expanded(child: SizedBox(height: 42));
                      }
                      final date = DateTime(_calendarMonth.year, _calendarMonth.month, dayNum);
                      final isAvailable = _isDateAvailable(date);
                      final isSelected = _selectedDate != null &&
                        _selectedDate!.year == date.year &&
                        _selectedDate!.month == date.month &&
                        _selectedDate!.day == date.day;
                      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                      
                      return Expanded(
                        child: GestureDetector(
                          onTap: isAvailable ? () => setState(() => _selectedDate = date) : null,
                          child: Container(
                            height: 42,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected
                                ? AppTheme.leafGreen
                                : isToday
                                  ? (isDark ? AppTheme.mintGreen.withOpacity(0.15) : AppTheme.mintGreen.withOpacity(0.12))
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: isToday && !isSelected
                                ? Border.all(color: AppTheme.mintGreen, width: 1.5)
                                : null,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNum',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                    ? Colors.white
                                    : !isAvailable
                                      ? (isDark ? Colors.grey.shade700 : Colors.grey.shade300)
                                      : (isDark ? Colors.white : AppTheme.forestGreen),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
              const SizedBox(height: 12),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: AppTheme.leafGreen, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text('Selected', style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                  const SizedBox(width: 16),
                  Container(width: 10, height: 10, decoration: BoxDecoration(border: Border.all(color: AppTheme.mintGreen, width: 1.5), borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text('Today', style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                  const SizedBox(width: 16),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text('Unavailable', style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                ],
              ),
            ],
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0D9488), Color(0xFF10B981)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendarCheck, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pickup Date', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    Text(
                      '${_selectedDate!.day} ${months[_selectedDate!.month - 1]} ${_selectedDate!.year}',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Text('10AM - 1PM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddressStep() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<AppState>(
      builder: (context, state, child) {
        final address = state.addresses.isNotEmpty
            ? state.addresses.firstWhere(
                (a) => a.isDefault,
                orElse: () => state.addresses.first,
              )
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pickup\nAddress',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(
                fontSize: 48,
                height: 1.1,
                color: isDark ? Colors.white : AppTheme.forestGreen,
              ),
            ),
            const SizedBox(height: 48),
            if (address != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : AppTheme.leafGreen.withOpacity(0.1),
                  border: Border.all(
                    color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.mapPin,
                        color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.forestGreen,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${address.houseName}, ${address.area}',
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.check,
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressManagementScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.plus,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add New Address',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact\nDetails',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 48, height: 1.1),
        ),
        const SizedBox(height: 48),
        _buildInputField(
          'PICKUP CONTACT NAME',
          _contactNameController,
          LucideIcons.user,
          'John Doe',
        ),
        const SizedBox(height: 24),
        _buildInputField(
          'PRIMARY PHONE NUMBER',
          _contactNumberController,
          LucideIcons.phone,
          'Mobile Number',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          'ADDITIONAL INSTRUCTIONS',
          _instructionsController,
          LucideIcons.messageSquare,
          'Tell the associate anything important...',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.forestGreen,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: maxLines > 1 ? 48.0 : 0),
              child: Icon(icon, color: isDark ? Colors.grey.shade400 : Colors.grey.shade400),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 32),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 32),
              borderSide: BorderSide(color: isDark ? AppTheme.mintGreen : AppTheme.leafGreen, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
