import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation_model.dart';
import '../utils/constants.dart';

class ReservationService {
  // Fetch all reservations
  Future<List<ReservationModel>> getAllReservations() async {
    final response = await http.get(Uri.parse('${Constants.uri}/reservations'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);

      // Map each reservation JSON to a ReservationModel instance
      List<ReservationModel> reservations =
          body.map((dynamic item) => ReservationModel.fromJson(item)).toList();

      return reservations;
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  // Fetch a reservation by ID
  Future<ReservationModel> getReservationById(String reservationId) async {
    final response = await http
        .get(Uri.parse('${Constants.uri}/reservations/$reservationId'));

    if (response.statusCode == 200) {
      return ReservationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load reservation details');
    }
  }

  // Fetch reservations by user ID
  Future<List<ReservationModel>> getReservationsByUserId(String userId) async {
    final response =
        await http.get(Uri.parse('${Constants.uri}/reservations/user/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);

      // Map each reservation JSON to a ReservationModel instance
      List<ReservationModel> reservations =
          body.map((dynamic item) => ReservationModel.fromJson(item)).toList();

      return reservations;
    } else {
      throw Exception('Failed to load user reservations');
    }
  }

  // Create a new reservation
  Future<ReservationModel> createReservation(
      ReservationModel reservation) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/reservations/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reservation.toJson()),
    );

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      return ReservationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to create reservation. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Update an existing reservation
  Future<void> updateReservation(
      String reservationId, ReservationModel reservation) async {
    final response = await http.put(
      Uri.parse('${Constants.uri}/reservations/$reservationId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update reservation');
    }
  }

  // Delete a reservation by ID
  Future<void> deleteReservation(String reservationId) async {
    final response = await http
        .delete(Uri.parse('${Constants.uri}/reservations/$reservationId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete reservation');
    }
  }
}
