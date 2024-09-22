import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import '../utils/constants.dart';

class BookingService {
  // Fetch all bookings
  Future<List<BookingModel>> getAllBookings() async {
    final response = await http.get(Uri.parse('${Constants.uri}/bookings'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);

      // Map each booking JSON to a BookingModel instance
      List<BookingModel> bookings =
          body.map((dynamic item) => BookingModel.fromJson(item)).toList();

      return bookings;
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Fetch a booking by ID
  Future<BookingModel> getBookingById(String bookingId) async {
    final response =
        await http.get(Uri.parse('${Constants.uri}/bookings/$bookingId'));

    if (response.statusCode == 200) {
      return BookingModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load booking details');
    }
  }

  // Fetch bookings by user ID
  Future<List<BookingModel>> getBookingsByUserId(String userId) async {
    final response =
        await http.get(Uri.parse('${Constants.uri}/bookings/user/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);

      // Map each booking JSON to a BookingModel instance
      List<BookingModel> bookings =
          body.map((dynamic item) => BookingModel.fromJson(item)).toList();

      return bookings;
    } else {
      throw Exception('Failed to load user bookings');
    }
  }

  Future<BookingModel> createBooking(BookingModel booking) async {
    final response = await http.post(
      Uri.parse('${Constants.uri}/bookings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(booking.toJson()),
    );

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      return BookingModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to create booking. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Update an existing booking
  Future<void> updateBooking(String bookingId, BookingModel booking) async {
    final response = await http.put(
      Uri.parse('${Constants.uri}/bookings/$bookingId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(booking.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booking');
    }
  }

  // Delete a booking by ID
  Future<void> deleteBooking(String bookingId) async {
    final response =
        await http.delete(Uri.parse('${Constants.uri}/bookings/$bookingId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete booking');
    }
  }
}
