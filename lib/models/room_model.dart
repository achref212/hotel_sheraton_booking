class RoomModel {
  final String id;
  final String name;
  final String location;
  final String imagePath;
  final String description;
  final double price;
  bool isFavorite; // New field to track favorite status

  RoomModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imagePath,
    required this.description,
    required this.price,
    this.isFavorite = false, // Default to not favorite
  });
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['_id'] ?? '',
      name: json['number'] ?? 'Unknown Room', // Provide default value if null
      location: json['type'] ?? 'Unknown Location', // Default value if null
      imagePath: json['image_path'], // Use just the file name in Flutter
      description: json['description'],
      // Use just the file name in Flutter
      price: (json['price'] != null)
          ? json['price'].toDouble()
          : 0.0, // Handle null price
    );
  }
  /*
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['_id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      price: json['price'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      imageUrl: json['imageUrl'] ?? 'default_image.png',
    );
  }*/
}
