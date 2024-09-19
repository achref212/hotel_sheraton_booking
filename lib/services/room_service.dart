import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room_model.dart';
import '../utils/constants.dart';

class RoomService {
  // Fetch all rooms
  Future<List<RoomModel>> getAllRooms() async {
    final response = await http.get(Uri.parse('${Constants.uri}/rooms'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((room) => RoomModel.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  // Fetch a room by ID
  Future<RoomModel> getRoomById(String roomId) async {
    final response =
        await http.get(Uri.parse('${Constants.uri}/rooms/$roomId'));
    if (response.statusCode == 200) {
      return RoomModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load room details');
    }
  }

  // Create a new room

  // Fetch recommended rooms for a user
  Future<List<RoomModel>> getRoomRecommendations(String userId) async {
    final response = await http
        .get(Uri.parse('${Constants.uri}/recommendations/rooms/$userId'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((room) => RoomModel.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load room recommendations');
    }
  }
}
