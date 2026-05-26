import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:reloop/models/booking.dart';
import '../../../../theme.dart';
import '../../../../providers/app_state.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../painters/kerala_outline_painter.dart';
import '../../../../screens/booking_flow_screen.dart';
import '../../../../core/services/location_service.dart';
import '../../../../screens/profile/notification_history_screen.dart';
import '../../../../screens/location/location_permission_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isLoadingHome = false;
  late final PageController _offersPageController;
  int _currentOfferIndex = 0;
  Timer? _offersTimer;
  bool _isServiceAvailable = true;

  @override
  void initState() {
    super.initState();
    _offersPageController = PageController();
    _startOffersTimer();
    _loadLocationOnStartup();
  }

  Future<void> _loadLocationOnStartup() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      if (appState.currentLocationAddress ==
          '123 Green Valley Road, Eco Park, City Center') {
        final loc = await LocationService.getCurrentLocation();
        if (mounted) {
          appState.updateCurrentLocationAddress(
            '${loc.city}, ${loc.region} (${loc.zip})',
            loc.latitude,
            loc.longitude,
          );
        }
      }
    } catch (_) {}
  }

  void _startOffersTimer() {
    _offersTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_offersPageController.hasClients) {
        final nextIndex = _offersPageController.page!.round() + 1;
        _offersPageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuint,
        );
      }
    });
  }

  @override
  void dispose() {
    _offersTimer?.cancel();
    _offersPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final hPad = context.scalePadding(24.0);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoadingHome = true;
        });
        await Future.delayed(const Duration(milliseconds: 1500));
        setState(() {
          _isLoadingHome = false;
        });
      },
      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: _isLoadingHome
          ? _buildHomeSkeleton(context, hPad, isDark)
          : (context.isTablet || context.isLandscape)
          ? _buildTabletHomeLayout(context, hPad, isDark)
          : _buildMobileHomeLayout(context, hPad, isDark),
    );
  }

  Widget _buildHomeSkeleton(BuildContext context, double hPad, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.grey.shade200;
    final shimmerColor = isDark ? Colors.white10 : Colors.white60;

    Widget skeletonBox({
      required double width,
      required double height,
      double borderRadius = 16,
    }) {
      return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 1500.ms, color: shimmerColor);
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 120),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                skeletonBox(width: 48, height: 48, borderRadius: 16),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    skeletonBox(width: 100, height: 20),
                    const SizedBox(height: 6),
                    skeletonBox(width: 140, height: 12),
                  ],
                ),
              ],
            ),
            skeletonBox(width: 40, height: 40, borderRadius: 20),
          ],
        ),
        const SizedBox(height: 32),
        skeletonBox(width: 120, height: 16),
        const SizedBox(height: 16),
        skeletonBox(width: double.infinity, height: 200, borderRadius: 32),
        const SizedBox(height: 32),
        skeletonBox(width: 180, height: 16),
        const SizedBox(height: 16),
        skeletonBox(width: double.infinity, height: 80, borderRadius: 24),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: skeletonBox(
                width: double.infinity,
                height: 120,
                borderRadius: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: skeletonBox(
                width: double.infinity,
                height: 120,
                borderRadius: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        skeletonBox(width: 100, height: 16),
        const SizedBox(height: 16),
        Row(
          children: [
            skeletonBox(width: 110, height: 140, borderRadius: 24),
            const SizedBox(width: 12),
            skeletonBox(width: 110, height: 140, borderRadius: 24),
            const SizedBox(width: 12),
            skeletonBox(width: 110, height: 140, borderRadius: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileHomeLayout(
    BuildContext context,
    double hPad,
    bool isDark,
  ) {
    return ListView(
      padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 120),
      children: [
        _buildWelcomeHeader(context, isDark),
        const SizedBox(height: 32),
        _buildOffersSection(context, isDark),
        const SizedBox(height: 32),
        _buildScheduledPickupCard(context, isDark),
        const SizedBox(height: 32),
        _buildQuickStartSection(context, isDark),
        const SizedBox(height: 24),
        _buildLocationBar(context, isDark),
        const SizedBox(height: 32),
        _buildPointsAndInfoSection(context, isDark),
        const SizedBox(height: 32),
        _buildPricingSection(context, isDark),
        const SizedBox(height: 32),
        _buildReviewsSection(context, isDark),
        const SizedBox(height: 32),
        _buildReferralBanner(context, isDark),
      ],
    );
  }

  Widget _buildTabletHomeLayout(
    BuildContext context,
    double hPad,
    bool isDark,
  ) {
    return ListView(
      padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, 120),
      children: [
        _buildWelcomeHeader(context, isDark),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOffersSection(context, isDark),
                  const SizedBox(height: 32),
                  _buildScheduledPickupCard(context, isDark),
                  const SizedBox(height: 32),
                  _buildReferralBanner(context, isDark),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationBar(context, isDark),
                  const SizedBox(height: 24),
                  _buildQuickStartSection(context, isDark),
                  const SizedBox(height: 32),
                  _buildPointsAndInfoSection(context, isDark),
                  const SizedBox(height: 32),
                  _buildPricingSection(context, isDark),
                  const SizedBox(height: 32),
                  _buildReviewsSection(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: AppTheme.getClayDecoration(
                  color: AppTheme.forestGreen,
                ),
                child: const Icon(
                  LucideIcons.treeDeciduous,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ReLoop',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: context.scaleFont(24),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.forestGreen,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'PREMIUM RECYCLING',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.lightGreen,
                        fontSize: context.scaleFont(10),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationHistoryScreen(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: AppTheme.getClayDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: 16,
                    ),
                    child: Icon(
                      LucideIcons.bell,
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      size: 20,
                    ),
                  ),
                ),
                Consumer<AppState>(
                  builder: (context, appState, _) {
                    final unreadCount = appState.unreadNotificationsCount;
                    if (unreadCount == 0) return const SizedBox.shrink();
                    return Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 12),
            Consumer<AppState>(
              builder: (context, appState, _) {
                final initials = appState.userName.isNotEmpty
                    ? appState.userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                    : 'U';
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.mintGreen.withValues(alpha: 0.15)
                        : AppTheme.forestGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'sparkles':
        return LucideIcons.sparkles;
      case 'users':
        return LucideIcons.users;
      case 'crown':
        return LucideIcons.crown;
      default:
        return LucideIcons.gift;
    }
  }

  Widget _buildOffersSection(BuildContext context, bool isDark) {
    final appState = Provider.of<AppState>(context);
    final List<Map<String, dynamic>> offersList = appState.offers.isNotEmpty
        ? appState.offers.map((o) {
            Color parseColor(dynamic value, Color fallback) {
              if (value == null) return fallback;
              if (value is Color) return value;
              final str = value.toString();
              try {
                if (str.startsWith('0x')) {
                  return Color(int.parse(str));
                } else if (str.startsWith('#')) {
                  return Color(int.parse(str.replaceFirst('#', '0xFF')));
                } else {
                  return Color(int.parse(str));
                }
              } catch (_) {
                return fallback;
              }
            }

            return {
              'title': o['title'] ?? '',
              'desc': o['desc'] ?? '',
              'color': parseColor(
                o['colorHex'] ?? o['color'],
                const Color(0xFF1D4ED8),
              ),
              'icon': o['icon'] is IconData
                  ? o['icon']
                  : _getIconData(o['iconName']?.toString() ?? 'gift'),
              'modalTitle': o['modalTitle'] ?? o['title'] ?? '',
              'modalDesc': o['modalDesc'] ?? o['desc'] ?? '',
              'iconColor': parseColor(
                o['iconColorHex'] ?? o['iconColor'],
                Colors.amber,
              ),
            };
          }).toList()
        : AppConstants.offers;

    final offerHeight = context.isTablet ? 280.0 : 240.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OFFERS & NEWS',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: context.scaleFont(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: offerHeight,
          child: PageView.builder(
            controller: _offersPageController,
            onPageChanged: (index) {
              if (offersList.isNotEmpty) {
                setState(() {
                  _currentOfferIndex = index % offersList.length;
                });
              }
            },
            itemBuilder: (context, i) {
              if (offersList.isEmpty) return const SizedBox.shrink();
              final index = i % offersList.length;
              final offer = offersList[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: offer['color'] as Color,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          offer['title'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: context.scaleFont(24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer['desc'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: context.scaleFont(14),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(32),
                                    topRight: Radius.circular(32),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              offer['icon'] as IconData,
                                              color:
                                                  offer['iconColor'] as Color,
                                              size: 32,
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              offer['modalTitle'] as String,
                                              style: TextStyle(
                                                fontSize: context.scaleFont(24),
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? Colors.white
                                                    : AppTheme.forestGreen,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDark
                                                  ? Colors.white.withOpacity(
                                                      0.1,
                                                    )
                                                  : Colors.grey.shade200,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              LucideIcons.x,
                                              size: 20,
                                              color: isDark
                                                  ? Colors.white
                                                  : AppTheme.forestGreen,
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    Text(
                                      'DETAILS & REQUIREMENTS',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: context.scaleFont(10),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      offer['modalDesc'] as String,
                                      style: TextStyle(
                                        fontSize: context.scaleFont(16),
                                        color: isDark
                                            ? Colors.grey.shade300
                                            : AppTheme.forestGreen,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          offer['title'] == "Eco Warrior"
                                              ? ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Coming Soon!!!',
                                                    ),
                                                  ),
                                                )
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BookingFlowScreen(),
                                                  ),
                                                );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDark
                                              ? AppTheme.mintGreen
                                              : AppTheme.forestGreen,
                                          foregroundColor: isDark
                                              ? const Color(0xFF0F172A)
                                              : Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child:
                                            offer['modalTitle'] == "Eco Warrior"
                                            ? const Text(
                                                'Coming Soon!!!',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : const Text(
                                                'BOOK PICKUP',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: offer['color'] as Color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: offer['title'] == "Eco Warrior"
                              ? const Text(
                                  'Coming Soon!!!',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  'CLAIM NOW',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        offer['icon'] as IconData,
                        color: Colors.white.withOpacity(0.15),
                        size: 160,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledPickupCard(BuildContext context, bool isDark) {
    final appState = Provider.of<AppState>(context);
    final activeBookings = appState.bookings
        .where(
          (b) =>
              b.status != BookingStatus.completed &&
              b.status != BookingStatus.cancelled,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCHEDULED PICK-UP',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: context.scaleFont(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        if (activeBookings.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.getClayDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.mintGreen : AppTheme.leafGreen)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.sparkles,
                    color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Recycling Today!',
                        style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No active pickups scheduled.',
                        style: TextStyle(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          fontSize: context.scaleFont(12),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingFlowScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppTheme.mintGreen
                        : AppTheme.forestGreen,
                    foregroundColor: isDark
                        ? const Color(0xFF0F172A)
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'BOOK',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        else
          _buildActiveBookingCard(context, activeBookings.first, isDark),
      ],
    );
  }

  Widget _buildActiveBookingCard(
    BuildContext context,
    Booking booking,
    bool isDark,
  ) {
    Color statusColor;
    switch (booking.status) {
      case BookingStatus.assigned:
      case BookingStatus.onTheWay:
      case BookingStatus.pickupStarted:
        statusColor = Colors.blue.shade400;
        break;
      default:
        statusColor = Colors.orange.shade400;
    }

    return GestureDetector(
      onTap: () => _showPickupDetails(context, booking),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.getClayDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.mintGreen.withOpacity(0.15)
                        : AppTheme.leafGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    LucideIcons.truck,
                    color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.scrapType,
                        style: TextStyle(
                          fontSize: context.scaleFont(16),
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Estimated Value: ₹${booking.estimatedPayout.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.mintGreen
                              : AppTheme.lightGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: context.scaleFont(12),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  LucideIcons.calendar,
                  size: 16,
                  color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${booking.scheduledDate} • ${booking.scheduledSlot}',
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade300
                          : Colors.grey.shade600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK START',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: context.scaleFont(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        if (_isServiceAvailable)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingFlowScreen(),
                ),
              );
            },
            child:
                Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 32,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.forestGreen, Color(0xFF1E5631)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.forestGreen.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Book Pickup',
                                    style: TextStyle(
                                      fontSize: context.scaleFont(24),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    LucideIcons.arrowRight,
                                    color: AppTheme.leafGreen,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Schedule in seconds',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: context.scaleFont(12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .shimmer(duration: 2000.ms, color: Colors.white24),
          )
        else
          GestureDetector(
            onTap: () => _showServiceZonesModal(context),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.alertTriangle,
                        color: Colors.orange.shade400,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Service Unavailable',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We are currently expanding. Tap to view our active service zones in Kerala.',
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildZoneChip('Kochi', true),
                      _buildZoneChip('Thrissur', true),
                      _buildZoneChip('Calicut', false),
                      _buildZoneChip('Trivandrum', false),
                      _buildZoneChip('Kannur', false),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.leafGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF334155)
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationBar(BuildContext context, bool isDark) {
    final appState = Provider.of<AppState>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 24,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.mintGreen.withOpacity(0.15)
                  : AppTheme.leafGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.mapPin,
              size: 16,
              color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  appState.currentLocationAddress,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationPermissionScreen(),
                ),
              );
            },
            child: Text(
              'CHANGE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsAndInfoSection(BuildContext context, bool isDark) {
    final appState = Provider.of<AppState>(context);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showPointsHistory(context),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: AppTheme.forestGreen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.zap,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '${appState.ecoPoints}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ECOPOINTS',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => _showAppInfo(context),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: AppTheme.forestGreen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.info,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'What is\nReLoop?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection(BuildContext context, bool isDark) {
    final appState = Provider.of<AppState>(context);
    final prices = appState.scrapPrices;

    final dynamicPricingItems = [
      {
        'name': 'Paper',
        'price': '₹${(prices['Newspaper'] ?? 17.0).toStringAsFixed(0)}',
        'icon': LucideIcons.bookOpen,
        'details':
            'Includes old newspapers, magazines, and notebooks. Please ensure they are dry and not contaminated with food waste.',
      },
      {
        'name': 'Cardboard',
        'price': '₹${(prices['Cardboard'] ?? 10.0).toStringAsFixed(0)}',
        'icon': LucideIcons.package,
        'details':
            'Shipping boxes, packaging, and brown paper. Please flatten the boxes to save space.',
      },
      {
        'name': 'Books',
        'price': '₹${(prices['Books'] ?? 16.0).toStringAsFixed(0)}',
        'icon': LucideIcons.library,
        'details':
            'Old textbooks, novels, and hardbounds. Heavily damaged or missing covers are also accepted.',
      },
      {
        'name': 'Office Paper',
        'price': '₹${(prices['Office Paper'] ?? 14.0).toStringAsFixed(0)}',
        'icon': LucideIcons.fileText,
        'details': 'Office documents, printing paper, and white paper files.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRICING (₹/KG)',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                fontSize: context.scaleFont(12),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              'DAILY RATES',
              style: TextStyle(
                color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                fontSize: context.scaleFont(10),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: dynamicPricingItems.length,
            itemBuilder: (context, index) {
              final item = dynamicPricingItems[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildPricingCard(
                  context,
                  item['name'] as String,
                  item['price'] as String,
                  item['icon'] as IconData,
                  item['details'] as String,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CUSTOMER REVIEWS',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: context.scaleFont(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: AppConstants.customerReviews.length,
            itemBuilder: (context, index) {
              final item = AppConstants.customerReviews[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildReviewCard(
                  item['name'],
                  item['review'],
                  item['rating'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReferralBanner(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REFER & EARN',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            fontSize: context.scaleFont(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.getClayDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite & Earn',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : AppTheme.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get 500 Eco Points for every friend you refer.',
                      style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming Soon!!!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.forestGreen,
                        foregroundColor: isDark
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'SHARE CODE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color:
                          (isDark ? AppTheme.mintGreen : AppTheme.forestGreen)
                              .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.gift,
                      size: 40,
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(duration: 2.seconds, curve: Curves.easeInOut),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    String name,
    String price,
    IconData icon,
    String details,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _showPricingDetails(context, name, price, icon, details),
      child: Container(
        width: context.scaleCardWidth(mobileRatio: 0.30, tabletRatio: 0.20),
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.getClayDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: 32,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                LucideIcons.info,
                size: 14,
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.shade300,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  void _showPricingDetails(
    BuildContext context,
    String name,
    String price,
    IconData icon,
    String details,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 48,
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: context.scaleFont(28),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.forestGreen,
                          ),
                        ),
                        Text(
                          '$price per KG',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.mintGreen
                                : AppTheme.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'DETAILS & REQUIREMENTS',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              details,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingFlowScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppTheme.mintGreen
                      : AppTheme.forestGreen,
                  foregroundColor: isDark
                      ? const Color(0xFF0F172A)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Schedule Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPointsHistory(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = Provider.of<AppState>(context, listen: false);
    final completedBookings = appState.bookings
        .where((b) => b.status == BookingStatus.completed)
        .toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Points History',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: completedBookings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.inbox,
                            size: 48,
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No points earned yet',
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Complete your first pickup to earn points!',
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: completedBookings.length,
                      itemBuilder: (context, index) {
                        final b = completedBookings[index];
                        return _buildHistoryRow(
                          context,
                          '${b.scrapType} Recycling',
                          '+${b.pointsEarned} pts',
                          b.scheduledDate,
                        ).animate().fadeIn(delay: (100 * (index + 1)).ms).slideY(begin: 0.1, end: 0);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryRow(
    BuildContext context,
    String title,
    String points,
    String date,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppTheme.forestGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            points,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.mintGreen : AppTheme.lightGreen,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'What is ReLoop?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'ReLoop is a modern sustainability and recycling platform designed to make recycling easy, rewarding, and transparent.\n\nWe connect households and businesses with reliable pickup staff, ensuring your scrap materials (like paper and cardboard) are ethically recycled.\n\nOur mission is to build a greener future while rewarding our community with ECOPOINTS for every contribution.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPickupDetails(BuildContext context, Booking booking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasPicker = booking.assignedPicker != null;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pickup Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      size: 20,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: isDark ? const Color(0xFF334155) : AppTheme.softBeige,
                borderRadius: 24,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 20,
                        color: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.forestGreen,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${booking.scheduledDate} • ${booking.scheduledSlot}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.forestGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 20,
                        color: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.forestGreen,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          booking.address.addressLine,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.forestGreen,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.getClayDecoration(
                color: isDark ? const Color(0xFF334155) : Colors.white,
                borderRadius: 24,
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.mintGreen.withOpacity(0.15)
                          : AppTheme.leafGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.user,
                      color: isDark ? AppTheme.mintGreen : AppTheme.forestGreen,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasPicker
                              ? booking.assignedPicker!.name
                              : 'Assigning Driver...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.forestGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasPicker
                              ? 'Vehicle: ${booking.assignedPicker!.vehicleNumber}'
                              : 'We are matching a driver nearby',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            if (hasPicker)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Open dialer or print action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Calling राजेश (${booking.assignedPicker!.mobileNumber})...',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(LucideIcons.phone, size: 18),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.forestGreen,
                        foregroundColor: isDark
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Opening WhatsApp message to ${booking.assignedPicker!.mobileNumber}...',
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        LucideIcons.messageCircle,
                        size: 18,
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : AppTheme.forestGreen,
                      ),
                      label: Text(
                        'WhatsApp',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : AppTheme.forestGreen,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppTheme.mintGreen.withOpacity(0.15)
                            : AppTheme.lightGreen.withOpacity(0.1),
                        foregroundColor: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.forestGreen,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showCancelPickup(context, booking);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Cancel Pickup',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showCancelPickup(BuildContext context, Booking booking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          top: 32,
          left: 32,
          right: 32,
        ),
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
            const Text(
              'Cancel Pickup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please let us know why you are canceling this pickup.',
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Reason for cancellation',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF0F172A)
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: isDark
                            ? AppTheme.mintGreen
                            : AppTheme.forestGreen,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final appState = Provider.of<AppState>(
                        context,
                        listen: false,
                      );
                      appState.cancelBooking(booking.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pickup cancelled successfully.'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirm Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, String review, int rating) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: context.scaleCardWidth(mobileRatio: 0.72, tabletRatio: 0.45),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.getClayDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppTheme.forestGreen,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? LucideIcons.star : LucideIcons.starHalf,
                    size: 16,
                    color: index < rating
                        ? Colors.amber
                        : (isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.shade300),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              '"$review"',
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneChip(String name, bool isActive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark
                  ? AppTheme.mintGreen.withOpacity(0.2)
                  : AppTheme.leafGreen.withOpacity(0.15))
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? (isDark
                    ? AppTheme.mintGreen.withOpacity(0.4)
                    : AppTheme.leafGreen.withOpacity(0.4))
              : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive
              ? (isDark ? AppTheme.mintGreen : AppTheme.forestGreen)
              : (isDark ? Colors.grey.shade400 : Colors.grey.shade500),
        ),
      ),
    );
  }

  void _showServiceZonesModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Zones',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.forestGreen,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    LucideIcons.x,
                    color: isDark ? Colors.grey.shade400 : null,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'KERALA, INDIA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                        : [const Color(0xFFE0F2FE), const Color(0xFFF0FDF4)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : Colors.grey.shade200,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;

                    return Stack(
                      children: [
                        CustomPaint(
                          size: Size(w, h),
                          painter: KeralaOutlinePainter(isDark: isDark),
                        ),
                        ...AppConstants.coverageZones.map((z) {
                          final isActive = z['active'] as bool;
                          final name = z['name'] as String;
                          final px = (z['x'] as double) * w;
                          final py = (z['y'] as double) * h;
                          return Positioned(
                            left: px - 30,
                            top: py - 10,
                            child: _buildMapZoneMarker(name, isActive),
                          );
                        }),
                        Positioned(
                          bottom: 12,
                          right: 16,
                          child: Text(
                            'ReLoop Coverage',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: AppConstants.coverageZones.length,
                itemBuilder: (context, index) {
                  final z = AppConstants.coverageZones[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: _buildZoneListItem(
                      z['name'],
                      z['status'],
                      z['active'],
                      isDark,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapZoneMarker(String name, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.mintGreen : Colors.grey.shade400,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.mintGreen.withOpacity(0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: const Icon(LucideIcons.mapPin, size: 14, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.forestGreen.withOpacity(0.8)
                : Colors.grey.shade600.withOpacity(0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZoneListItem(
    String zone,
    String status,
    bool isActive,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark
                  ? AppTheme.mintGreen.withOpacity(0.12)
                  : AppTheme.leafGreen.withOpacity(0.08))
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? (isDark
                    ? AppTheme.mintGreen.withOpacity(0.3)
                    : AppTheme.leafGreen.withOpacity(0.1))
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.mintGreen : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            zone,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? (isDark ? Colors.white : AppTheme.forestGreen)
                  : Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppTheme.mintGreen : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
