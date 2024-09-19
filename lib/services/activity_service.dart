import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';
import '../utils/constants.dart';

class ActivityService {
  // Fetch all activities
  Future<List<ActivityModel>> getAllActivities() async {
    final response = await http.get(Uri.parse('${Constants.uri}/activities'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return ActivityModel.fromJsonList(jsonResponse.toList());
    } else {
      throw Exception('Failed to load activities');
    }
  }

  // Fetch activity by ID
  Future<ActivityModel> getActivityById(String activityId) async {
    final response =
        await http.get(Uri.parse('${Constants.uri}/activities/$activityId'));
    if (response.statusCode == 200) {
      return ActivityModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load activity details');
    }
  }

  // Create a new activity
  Future<void> createActivity(ActivityModel newActivity) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/activities'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(newActivity.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create activity');
    }
  }

  // Update an activity
  Future<void> updateActivity(ActivityModel updatedActivity) async {
    final response = await http.put(
      Uri.parse('${Constants.uri}/activities/${updatedActivity.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedActivity.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update activity');
    }
  }

  // Delete an activity by ID
  Future<void> deleteActivity(String activityId) async {
    final response =
        await http.delete(Uri.parse('${Constants.uri}/activities/$activityId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }

  // Fetch activity recommendations for a user
  Future<List<ActivityModel>> getActivityRecommendations(String userId) async {
    final response = await http
        .get(Uri.parse('${Constants.uri}/recommendations/activities/$userId'));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return ActivityModel.fromJsonList(jsonResponse.toList());
    } else {
      throw Exception('Failed to load activity recommendations');
    }
  }
}
