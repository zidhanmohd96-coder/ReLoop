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
  List<String> _selectedScrapTypes = [];
  String? _selectedQuantity;

  String? _selectedSchedule;

  final _contactNameController = TextEditingController(text: 'zimu');
  final _contactNumberController = TextEditingController();
  final _instructionsController = TextEditingController();

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

  final List<String> _schedules = [
    'Tomorrow',
    'Wed, 14 May',
    'Thu, 15 May',
    'Fri, 16 May',
  ];

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
    if (_currentStep == 2 && _selectedSchedule == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a schedule')));
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'STEP ${_currentStep + 1} OF $_totalSteps',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              _getStepTitle(),
              style: const TextStyle(
                color: AppTheme.forestGreen,
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
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                LucideIcons.chevronLeft,
                color: AppTheme.forestGreen,
                size: 20,
              ),
              onPressed: _prevStep,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F7F4), Color(0xFFE4F0E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
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
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _prevStep,
              icon: const Icon(
                LucideIcons.chevronLeft,
                color: AppTheme.forestGreen,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.forestGreen,
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
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: Colors.white,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are we\nrecycling?',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 48, height: 1.1),
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
                      color: Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.forestGreen
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        if (!isSelected)
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
                          color: AppTheme.forestGreen,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          type['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.forestGreen,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimate\nQuantity',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 48, height: 1.1),
        ),
        const SizedBox(height: 48),
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
                      ? AppTheme.leafGreen.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.forestGreen
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.scale,
                        color: AppTheme.forestGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        q,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.forestGreen,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppTheme.forestGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildScheduleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick a\nSchedules',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 48, height: 1.1),
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
          itemCount: _schedules.length,
          itemBuilder: (context, index) {
            final schedule = _schedules[index];
            final isSelected = _selectedSchedule == schedule;
            return GestureDetector(
              onTap: () => setState(() => _selectedSchedule = schedule),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.leafGreen.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.forestGreen
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.calendar,
                      size: 32,
                      color: AppTheme.forestGreen,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      schedule,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.forestGreen,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'AVAILABLE',
                      style: TextStyle(
                        color: AppTheme.lightGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddressStep() {
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
              ).textTheme.displayMedium?.copyWith(fontSize: 48, height: 1.1),
            ),
            const SizedBox(height: 48),
            if (address != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.leafGreen.withOpacity(0.1),
                  border: Border.all(color: AppTheme.forestGreen, width: 2),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.mapPin,
                        color: AppTheme.forestGreen,
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.forestGreen,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${address.houseName}, ${address.area}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.check, color: AppTheme.forestGreen),
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
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.plus,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add New Address',
                      style: TextStyle(
                        color: Colors.grey.shade400,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
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
          style: const TextStyle(
            color: AppTheme.forestGreen,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: maxLines > 1 ? 48.0 : 0),
              child: Icon(icon, color: Colors.grey.shade400),
            ),
            filled: true,
            fillColor: Colors.white,
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
              borderSide: const BorderSide(color: AppTheme.leafGreen, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
