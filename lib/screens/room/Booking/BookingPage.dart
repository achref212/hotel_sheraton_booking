import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/models/booking_model.dart';
import 'package:hotel_sheraton_booking/services/booking_service.dart';

class BookingPage extends StatefulWidget {
  final String userId;
  final String roomId;

  BookingPage({required this.userId, required this.roomId});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final BookingService bookingService = BookingService();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int guests = 1;
  String bookingStatus = "pending";

  Future<void> _createBooking() async {
    try {
      // Validate the dates and guest count
      if (_checkInDate == null || _checkOutDate == null) {
        print("Check-in and check-out dates are required");
        return;
      }

      // Create a new booking model
      BookingModel booking = BookingModel(
        userId: widget.userId,
        roomId: widget.roomId,
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        guests: guests,
        status: bookingStatus,
      );

      // Call the booking service to create a booking
      BookingModel newBooking = await bookingService.createBooking(booking);

      print("Booking created successfully: ${newBooking.id}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking created successfully!")),
      );
    } catch (e) {
      print("Error creating booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create booking.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Booking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Check-in date picker
            ListTile(
              title: Text(_checkInDate == null
                  ? 'Select check-in date'
                  : 'Check-in: ${_checkInDate!.toLocal()}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    _checkInDate = date;
                  });
                }
              },
            ),

            // Check-out date picker
            ListTile(
              title: Text(_checkOutDate == null
                  ? 'Select check-out date'
                  : 'Check-out: ${_checkOutDate!.toLocal()}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    _checkOutDate = date;
                  });
                }
              },
            ),

            // Guests picker
            ListTile(
              title: Text('Guests: $guests'),
              trailing: DropdownButton<int>(
                value: guests,
                onChanged: (int? newValue) {
                  setState(() {
                    guests = newValue!;
                  });
                },
                items: List.generate(10, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ),

            // Create Booking button
            ElevatedButton(
              onPressed: _createBooking,
              child: Text("Create Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
