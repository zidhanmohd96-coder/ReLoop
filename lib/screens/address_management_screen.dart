import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/address.dart';
import '../providers/app_state.dart';
import '../theme.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softBeige,
      appBar: AppBar(
        title: const Text(
          'Saved Addresses',
          style: TextStyle(
            color: AppTheme.forestGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.forestGreen),
      ),
      body: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.map, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No addresses saved yet.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                  ),
                ],
              ).animate().fadeIn(),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: state.addresses.length,
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: AppTheme.getClayDecoration(
                      color: Colors.white,
                      borderRadius: 24,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: address.isDefault
                                ? AppTheme.leafGreen.withOpacity(0.1)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            address.isDefault
                                ? LucideIcons.checkCircle2
                                : LucideIcons.mapPin,
                            color: address.isDefault
                                ? AppTheme.forestGreen
                                : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    address.houseName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppTheme.forestGreen,
                                    ),
                                  ),
                                  if (address.isDefault)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.leafGreen,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'DEFAULT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${address.area}, ${address.city}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                'Pin: ${address.pincode}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  if (!address.isDefault)
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          state.updateAddress(
                                            address.copyWith(isDefault: true),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppTheme.forestGreen,
                                          side: const BorderSide(
                                            color: AppTheme.forestGreen,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Set Default',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (!address.isDefault)
                                    const SizedBox(width: 12),
                                  IconButton(
                                    onPressed: () {
                                      state.deleteAddress(address.id);
                                    },
                                    icon: Icon(
                                      LucideIcons.trash2,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: (index * 100).ms)
                  .slideY(begin: 0.1, end: 0);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressModal(context),
        backgroundColor: AppTheme.forestGreen,
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: const Text(
          'Add New Address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showAddAddressModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 32,
          right: 32,
          top: 32,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Address',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.forestGreen,
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.leafGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.leafGreen),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.mapPin,
                          color: AppTheme.forestGreen,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Use Current Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.forestGreen,
                            ),
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('House / Flat Name'),
                  const SizedBox(height: 16),
                  _buildTextField('Area / Locality'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('City')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Pincode')),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final appState = Provider.of<AppState>(
                          context,
                          listen: false,
                        );
                        appState.addAddress(
                          Address(
                            fullName: 'New User',
                            mobileNumber: '9876543210',
                            houseName: 'New Apartment',
                            area: 'Tech Park',
                            landmark: 'Near Station',
                            city: 'City Center',
                            pincode: '682024',
                            latitude: 0,
                            longitude: 0,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.forestGreen,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Save Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.forestGreen, width: 2),
        ),
      ),
    );
  }
}
