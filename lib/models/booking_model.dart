class BookingModel {
  final String?
      id; // ObjectId as String, nullable because it can be generated by backend
  final String userId;
  final String roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final String status; // e.g., 'confirmed', 'pending', 'cancelled'

  BookingModel({
    this.id, // Nullable id, will be generated by MongoDB if not provided
    required this.userId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.status,
  });

  // Factory constructor to create a BookingModel from JSON data
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ??
          json['booking_id'] ??
          '', // Use 'booking_id' if '_id' is not present
      userId: json['userId'] ?? 'UnknownUser', // Provide a default if null
      roomId: json['roomId'] ?? 'UnknownRoom', // Provide a default if null
      checkInDate: json['checkInDate'] != null
          ? DateTime.parse(json['checkInDate'])
          : DateTime.now(), // Default to current time if missing
      checkOutDate: json['checkOutDate'] != null
          ? DateTime.parse(json['checkOutDate'])
          : DateTime.now(), // Default to current time if missing
      guests: json['guests'] ?? 1, // Default to 1 if missing
      status: json['status'] ?? 'pending', // Default to 'pending' if missing
    );
  }

  // Method to convert a BookingModel object to JSON format
  Map<String, dynamic> toJson() {
    final data = {
      'userId': userId,
      'roomId': roomId,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'guests': guests,
      'status': status,
    };

    // Only include '_id' if it's not null (for existing bookings)
    if (id != null && id!.isNotEmpty) {
      data['_id'] = id!;
    }

    return data;
  }

  // Method to create a list of BookingModel from a list of JSON objects
  static List<BookingModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BookingModel.fromJson(json)).toList();
  }
}