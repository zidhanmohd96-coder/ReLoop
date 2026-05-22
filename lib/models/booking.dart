import 'package:uuid/uuid.dart';
import 'address.dart';
import 'picker.dart';

enum BookingStatus {
  pending,
  assigned,
  onTheWay,
  pickupStarted,
  completed,
  cancelled,
}

class Booking {
  final String id;
  final String scrapType;
  final String quantityEstimate;
  final DateTime pickupDate;
  final String pickupTimeSlot;
  final Address address;

  final String contactName;
  final String contactNumber;
  final String? alternateNumber;
  final String? instructions;

  final BookingStatus status;
  final Picker? assignedPicker;
  final String? assignedPickerId;

  // Staff-entered details on pickup
  final double actualWeightNewspaper;
  final double actualWeightCardboard;
  final double actualWeightBooks;
  final double actualWeightOfficePaper;
  
  final double totalPayoutAmount;
  final String? paymentMethod; // 'UPI', 'Cash'
  final String? proofImageUrl; // Stored path/url of photo

  Booking({
    String? id,
    required this.scrapType,
    required this.quantityEstimate,
    required this.pickupDate,
    required this.pickupTimeSlot,
    required this.address,
    required this.contactName,
    required this.contactNumber,
    this.alternateNumber,
    this.instructions,
    this.status = BookingStatus.pending,
    this.assignedPicker,
    this.assignedPickerId,
    this.actualWeightNewspaper = 0.0,
    this.actualWeightCardboard = 0.0,
    this.actualWeightBooks = 0.0,
    this.actualWeightOfficePaper = 0.0,
    this.totalPayoutAmount = 0.0,
    this.paymentMethod,
    this.proofImageUrl,
  }) : id = id ?? const Uuid().v4();

  Booking copyWith({
    BookingStatus? status,
    Picker? assignedPicker,
    String? assignedPickerId,
    double? actualWeightNewspaper,
    double? actualWeightCardboard,
    double? actualWeightBooks,
    double? actualWeightOfficePaper,
    double? totalPayoutAmount,
    String? paymentMethod,
    String? proofImageUrl,
  }) {
    return Booking(
      id: id,
      scrapType: scrapType,
      quantityEstimate: quantityEstimate,
      pickupDate: pickupDate,
      pickupTimeSlot: pickupTimeSlot,
      address: address,
      contactName: contactName,
      contactNumber: contactNumber,
      alternateNumber: alternateNumber,
      instructions: instructions,
      status: status ?? this.status,
      assignedPicker: assignedPicker ?? this.assignedPicker,
      assignedPickerId: assignedPickerId ?? this.assignedPickerId,
      actualWeightNewspaper: actualWeightNewspaper ?? this.actualWeightNewspaper,
      actualWeightCardboard: actualWeightCardboard ?? this.actualWeightCardboard,
      actualWeightBooks: actualWeightBooks ?? this.actualWeightBooks,
      actualWeightOfficePaper: actualWeightOfficePaper ?? this.actualWeightOfficePaper,
      totalPayoutAmount: totalPayoutAmount ?? this.totalPayoutAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      proofImageUrl: proofImageUrl ?? this.proofImageUrl,
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String?,
      scrapType: json['scrapType'] as String? ?? 'Paper',
      quantityEstimate: json['quantityEstimate'] as String? ?? 'Small (<5kg)',
      pickupDate: json['pickupDate'] != null 
          ? DateTime.parse(json['pickupDate'] as String) 
          : DateTime.now(),
      pickupTimeSlot: json['pickupTimeSlot'] as String? ?? '',
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      contactName: json['contactName'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      alternateNumber: json['alternateNumber'] as String?,
      instructions: json['instructions'] as String?,
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['status'] as String? ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      assignedPickerId: json['assignedPickerId'] as String?,
      assignedPicker: json['assignedPicker'] != null 
          ? Picker.fromJson(json['assignedPicker'] as Map<String, dynamic>) 
          : null,
      actualWeightNewspaper: (json['actualWeightNewspaper'] as num?)?.toDouble() ?? 0.0,
      actualWeightCardboard: (json['actualWeightCardboard'] as num?)?.toDouble() ?? 0.0,
      actualWeightBooks: (json['actualWeightBooks'] as num?)?.toDouble() ?? 0.0,
      actualWeightOfficePaper: (json['actualWeightOfficePaper'] as num?)?.toDouble() ?? 0.0,
      totalPayoutAmount: (json['totalPayoutAmount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String?,
      proofImageUrl: json['proofImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scrapType': scrapType,
      'quantityEstimate': quantityEstimate,
      'pickupDate': pickupDate.toIso8601String(),
      'pickupTimeSlot': pickupTimeSlot,
      'address': address.toJson(),
      'contactName': contactName,
      'contactNumber': contactNumber,
      'alternateNumber': alternateNumber,
      'instructions': instructions,
      'status': status.toString().split('.').last,
      'assignedPickerId': assignedPickerId,
      'assignedPicker': assignedPicker?.toJson(),
      'actualWeightNewspaper': actualWeightNewspaper,
      'actualWeightCardboard': actualWeightCardboard,
      'actualWeightBooks': actualWeightBooks,
      'actualWeightOfficePaper': actualWeightOfficePaper,
      'totalPayoutAmount': totalPayoutAmount,
      'paymentMethod': paymentMethod,
      'proofImageUrl': proofImageUrl,
    };
  }

  // Compatibility getters for screen UI layouts
  String get scheduledDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${pickupDate.day} ${months[pickupDate.month - 1]} ${pickupDate.year}';
  }

  String get scheduledSlot => pickupTimeSlot;

  double get estimatedWeight {
    final lower = quantityEstimate.toLowerCase();
    if (lower.contains('small') || lower.contains('<5')) return 3.0;
    if (lower.contains('medium') || lower.contains('5-20')) return 12.0;
    if (lower.contains('very large') || lower.contains('>50')) return 60.0;
    if (lower.contains('large') || lower.contains('20-50')) return 35.0;
    return 10.0;
  }

  double get estimatedPayout {
    return estimatedWeight * 12.0; // Average price estimation
  }

  int get pointsEarned {
    if (status == BookingStatus.completed) {
      return (totalPayoutAmount * 10).toInt();
    } else {
      return (estimatedPayout * 10).toInt();
    }
  }
}
