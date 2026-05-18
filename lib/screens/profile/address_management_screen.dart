import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/address.dart';
import '../../providers/app_state.dart';
import '../../theme.dart';
import '../../core/services/location_service.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Saved Addresses',
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
      body: Consumer<AppState>(
        builder: (context, state, child) {
          final filtered = state.addresses.where((a) {
            if (_searchQuery.isEmpty) return true;
            final q = _searchQuery.toLowerCase();
            return a.houseName.toLowerCase().contains(q) ||
                a.area.toLowerCase().contains(q) ||
                a.city.toLowerCase().contains(q) ||
                a.label.toLowerCase().contains(q);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Container(
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
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search addresses...',
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
              ),

              // Address count
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SAVED LOCATIONS',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF0D9488),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '${filtered.length} Address${filtered.length != 1 ? 'es' : ''}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Address list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.addresses.isEmpty
                                  ? 'No addresses saved yet'
                                  : 'No matching addresses',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the button below to add an address',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final address = filtered[index];
                          return _buildAddressCard(
                            address,
                            state,
                            isDark,
                            index,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressModal(context),
        backgroundColor: const Color(0xFF0D9488),
        elevation: 2,
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: const Text(
          'Add Address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAddressCard(
    Address address,
    AppState state,
    bool isDark,
    int index,
  ) {
    final labelIcon = address.label == 'Office'
        ? LucideIcons.building2
        : address.label == 'Other'
        ? LucideIcons.mapPin
        : LucideIcons.home;

    return Dismissible(
      key: Key(address.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(LucideIcons.trash2, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                title: const Text('Delete Address'),
                content: Text(
                  'Remove "${address.houseName}" from saved addresses?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => state.deleteAddress(address.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: address.isDefault
                ? const Color(0xFF0D9488).withOpacity(0.5)
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
            width: address.isDefault ? 1.5 : 1.0,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Label icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: address.isDefault
                        ? const Color(0xFF0D9488).withOpacity(0.1)
                        : (isDark
                              ? Colors.white.withOpacity(0.04)
                              : Colors.grey[50]!),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    labelIcon,
                    color: address.isDefault
                        ? const Color(0xFF0D9488)
                        : (isDark ? Colors.grey[400] : Colors.grey[500]),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.label,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0D9488),
                                    Color(0xFF10B981),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'DEFAULT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address.houseName,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[750],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // 3-dot menu
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  icon: Icon(
                    LucideIcons.moreVertical,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'default') {
                      state.updateAddress(address.copyWith(isDefault: true));
                    }
                    if (value == 'edit') {
                      _showAddAddressModal(context, editing: address);
                    }
                    if (value == 'delete') {
                      state.deleteAddress(address.id);
                    }
                  },
                  itemBuilder: (ctx) => [
                    if (!address.isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Text('Set as Default'),
                      ),
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Full address details
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.02)
                    : Colors.grey[50]!,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.02)
                      : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 14,
                        color: const Color(0xFF0D9488),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${address.area}, ${address.city} - ${address.pincode}',
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (address.landmark.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.landmark,
                          size: 14,
                          color: Color(0xFF0D9488),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          address.landmark,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.phone,
                        size: 14,
                        color: Color(0xFF0D9488),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        address.mobileNumber,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Quick defaults
            if (!address.isDefault) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => state.updateAddress(
                        address.copyWith(isDefault: true),
                      ),
                      icon: const Icon(
                        LucideIcons.checkCircle2,
                        size: 16,
                        color: Color(0xFF0D9488),
                      ),
                      label: const Text(
                        'Set Default Address',
                        style: TextStyle(
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: const Color(0xFF0D9488).withOpacity(0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.08, end: 0),
    );
  }

  void _showAddAddressModal(BuildContext context, {Address? editing}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final houseCtrl = TextEditingController(text: editing?.houseName ?? '');
    final areaCtrl = TextEditingController(text: editing?.area ?? '');
    final cityCtrl = TextEditingController(text: editing?.city ?? '');
    final pincodeCtrl = TextEditingController(text: editing?.pincode ?? '');
    final landmarkCtrl = TextEditingController(text: editing?.landmark ?? '');
    final nameCtrl = TextEditingController(text: editing?.fullName ?? '');
    final phoneCtrl = TextEditingController(text: editing?.mobileNumber ?? '');
    String selectedLabel = editing?.label ?? 'Home';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.88,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editing != null ? 'Edit Address' : 'New Address',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.forestGreen,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      LucideIcons.x,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    // Use current location
                    GestureDetector(
                      onTap: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text('Fetching current location...'),
                              ],
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        final loc = await LocationService.getCurrentLocation();

                        setModalState(() {
                          houseCtrl.text = 'Flat 4B, Eco Vista Residency';
                          areaCtrl.text = 'Cochin Eco Park';
                          cityCtrl.text = loc.city;
                          pincodeCtrl.text = loc.zip;
                          landmarkCtrl.text =
                              '${loc.region} (${loc.latitude.toStringAsFixed(3)}, ${loc.longitude.toStringAsFixed(3)})';
                        });

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Successfully loaded live location!',
                              ),
                              backgroundColor: Color(0xFF0D9488),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0D9488), Color(0xFF10B981)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.navigation,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Use Current Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Icon(
                              LucideIcons.chevronRight,
                              color: Colors.white.withOpacity(0.7),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label picker
                    Text(
                      'ADDRESS LABEL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Home', 'Office', 'Other'].map((label) {
                        final isSelected = selectedLabel == label;
                        final icon = label == 'Home'
                            ? LucideIcons.home
                            : label == 'Office'
                            ? LucideIcons.building2
                            : LucideIcons.mapPin;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setModalState(() => selectedLabel = label),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0D9488).withOpacity(0.1)
                                    : (isDark
                                          ? Colors.white.withOpacity(0.04)
                                          : Colors.grey[50]),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0D9488)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    icon,
                                    size: 20,
                                    color: isSelected
                                        ? const Color(0xFF0D9488)
                                        : Colors.grey[400],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? const Color(0xFF0D9488)
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Contact info
                    Text(
                      'CONTACT INFO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModalField(
                            'Full Name',
                            nameCtrl,
                            isDark,
                            icon: LucideIcons.user,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModalField(
                            'Phone',
                            phoneCtrl,
                            isDark,
                            icon: LucideIcons.phone,
                            keyboard: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'ADDRESS DETAILS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildModalField(
                      'House / Flat Name',
                      houseCtrl,
                      isDark,
                      icon: LucideIcons.home,
                    ),
                    const SizedBox(height: 12),
                    _buildModalField(
                      'Area / Locality',
                      areaCtrl,
                      isDark,
                      icon: LucideIcons.map,
                    ),
                    const SizedBox(height: 12),
                    _buildModalField(
                      'Landmark (optional)',
                      landmarkCtrl,
                      isDark,
                      icon: LucideIcons.landmark,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModalField(
                            'City',
                            cityCtrl,
                            isDark,
                            icon: LucideIcons.building,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildModalField(
                            'Pincode',
                            pincodeCtrl,
                            isDark,
                            icon: LucideIcons.hash,
                            keyboard: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final appState = Provider.of<AppState>(
                            context,
                            listen: false,
                          );
                          final newAddress = Address(
                            id: editing?.id,
                            fullName: nameCtrl.text.isEmpty
                                ? 'User'
                                : nameCtrl.text,
                            mobileNumber: phoneCtrl.text.isEmpty
                                ? '9876543210'
                                : phoneCtrl.text,
                            houseName: houseCtrl.text.isEmpty
                                ? 'My Place'
                                : houseCtrl.text,
                            area: areaCtrl.text.isEmpty
                                ? 'Area'
                                : areaCtrl.text,
                            landmark: landmarkCtrl.text,
                            city: cityCtrl.text.isEmpty
                                ? 'City'
                                : cityCtrl.text,
                            pincode: pincodeCtrl.text.isEmpty
                                ? '000000'
                                : pincodeCtrl.text,
                            latitude: 0,
                            longitude: 0,
                            label: selectedLabel,
                            isDefault:
                                editing?.isDefault ??
                                appState.addresses.isEmpty,
                          );
                          if (editing != null) {
                            appState.updateAddress(newAddress);
                          } else {
                            appState.addAddress(newAddress);
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          editing != null ? 'Update Address' : 'Save Address',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalField(
    String label,
    TextEditingController controller,
    bool isDark, {
    IconData? icon,
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: Colors.grey[400])
            : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: isDark
              ? BorderSide.none
              : BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
