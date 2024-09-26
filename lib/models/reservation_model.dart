class ReservationModel {
  final String?
      id; // ObjectId as String, nullable because it can be generated by the backend
  final String userId;
  final String activityId;
  final DateTime reservationDate;
  final int guests;
  final String status; // e.g., 'confirmed', 'pending', 'cancelled'

  ReservationModel({
    this.id, // Nullable id, will be generated by MongoDB if not provided
    required this.userId,
    required this.activityId,
    required this.reservationDate,
    required this.guests,
    required this.status,
  });

  // Factory constructor to create a ReservationModel from JSON data
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['_id'] ??
          json['reservation_id'] ??
          '', // Use 'reservation_id' if '_id' is not present
      userId: json['userId'] ?? 'UnknownUser', // Provide a default if null
      activityId:
          json['activityId'] ?? 'UnknownActivity', // Provide a default if null
      reservationDate: json['reservationDate'] != null
          ? DateTime.parse(json['reservationDate'])
          : DateTime.now(), // Default to current time if missing
      guests: json['guests'] ?? 1, // Default to 1 if missing
      status: json['status'] ?? 'pending', // Default to 'pending' if missing
    );
  }

  // Method to convert a ReservationModel object to JSON format
  Map<String, dynamic> toJson() {
    final data = {
      'userId': userId,
      'activityId': activityId,
      'reservationDate': reservationDate.toIso8601String(),
      'guests': guests,
      'status': status,
    };

    // Only include '_id' if it's not null (for existing reservations)
    if (id != null && id!.isNotEmpty) {
      data['_id'] = id!;
    }

    return data;
  }

  // Method to create a list of ReservationModel from a list of JSON objects
  static List<ReservationModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ReservationModel.fromJson(json)).toList();
  }
}
