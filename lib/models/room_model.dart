class RoomModel {
  final String id;
  final String name;
  final String location;
  final String description;
  final int price;
  final int maxParticipants;
  final int currentParticipants;
  final String imageUrl;

  RoomModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.price,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.imageUrl,
  });

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
  }
}
