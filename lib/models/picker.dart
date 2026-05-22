class Picker {
  final String id;
  final String name;
  final String photoUrl;
  final String mobileNumber;
  final String vehicleNumber;
  final double rating;
  final String status; // 'Active', 'Idle', 'Offline'

  Picker({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.mobileNumber,
    required this.vehicleNumber,
    required this.rating,
    this.status = 'Idle',
  });

  Picker copyWith({
    String? name,
    String? photoUrl,
    String? mobileNumber,
    String? vehicleNumber,
    double? rating,
    String? status,
  }) {
    return Picker(
      id: id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      rating: rating ?? this.rating,
      status: status ?? this.status,
    );
  }

  factory Picker.fromJson(Map<String, dynamic> json) {
    return Picker(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      status: json['status'] as String? ?? 'Idle',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'mobileNumber': mobileNumber,
      'vehicleNumber': vehicleNumber,
      'rating': rating,
      'status': status,
    };
  }
}
