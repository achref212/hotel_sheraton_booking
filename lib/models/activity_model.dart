class ActivityModel {
  final String id;
  final String name;
  final String location;
  final String description;
  final String startTime;
  final String endTime;
  final int price;
  final int maxParticipants;
  final int currentParticipants;
  final String imagePath;
  bool isFavorite; // New field to track favorite status

  ActivityModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.imagePath,
    this.isFavorite = false, // Default to not favorite
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['_id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      price: json['price'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      imagePath: json['image_path'], // Use just the file name in Flutter
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'price': price,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'images': imagePath,
    };
  }

  static List<ActivityModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ActivityModel.fromJson(json)).toList();
  }
}
