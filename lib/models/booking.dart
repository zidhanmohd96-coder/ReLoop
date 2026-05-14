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
  }) : id = id ?? const Uuid().v4();

  Booking copyWith({BookingStatus? status, Picker? assignedPicker}) {
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
    );
  }
}
