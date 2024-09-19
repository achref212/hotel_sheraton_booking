class ActivityModel {
  final String id;
  final String name;
  final String location;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final int price;
  final int maxParticipants;
  final int currentParticipants;
  final String imageUrl;

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
    required this.imageUrl,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['_id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      price: json['price'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      imageUrl: json['imageUrl'] ?? 'default_image.png',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'price': price,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'images': imageUrl,
    };
  }

  static List<ActivityModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ActivityModel.fromJson(json)).toList();
  }
}
