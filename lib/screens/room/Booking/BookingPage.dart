import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/models/room_model.dart';
import 'package:hotel_sheraton_booking/screens/room/Booking/Payment.dart';
import 'package:intl/intl.dart';
import 'package:hotel_sheraton_booking/models/booking_model.dart';
import 'package:hotel_sheraton_booking/services/booking_service.dart';

class BookingPage extends StatefulWidget {
  final String userId;
  final String roomId;
  final double roomPrice;
  final RoomModel room;

  BookingPage({
    required this.userId,
    required this.roomId,
    required this.roomPrice,
    required this.room,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final BookingService bookingService = BookingService();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int guests = 1;
  String bookingStatus = "pending";
  double totalPrice = 0;
  int nights = 0; // Add nights variable to calculate number of nights

  // Calculate total price
  void _calculateTotalPrice() {
    if (_checkInDate != null && _checkOutDate != null) {
      nights = _checkOutDate!.difference(_checkInDate!).inDays;
      setState(() {
        totalPrice = nights * widget.roomPrice * guests;
      });
    }
  }

  // Function to create booking
  Future<void> _createBooking() async {
    if (_checkInDate == null || _checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select check-in and check-out dates.")),
      );
      return;
    }

    try {
      BookingModel booking = BookingModel(
        userId: widget.userId,
        roomId: widget.roomId,
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        guests: guests,
        status: bookingStatus,
      );

      BookingModel newBooking = await bookingService.createBooking(booking);
      // If booking is created successfully, navigate to PaymentPage
      if (newBooking.id!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking created successfully!")),
        );

        // Navigate to PaymentPage after booking is successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              totalPrice: totalPrice,
              room: widget.room,
              nights: nights, // Pass the number of nights
              checkInDate: _checkInDate!, // Pass check-in date
              checkOutDate: _checkOutDate!, // Pass check-out date
              guests: guests, // Pass the number of guests
            ),
          ),
        );
      } else {
        // If the response does not contain a booking ID, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create booking. Please try again."),
          ),
        );
      }
    } catch (e) {
      // Show error if there's an exception
      print("Error creating booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  // Widget to select check-in and check-out dates
  Widget _buildDateSelector(
      String label, DateTime? date, Function(DateTime) onSelectDate) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onSelectDate(selectedDate);
          _calculateTotalPrice();
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null ? label : DateFormat.yMMMd().format(date),
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
    );
  }

  // Widget for selecting number of guests
  Widget _buildGuestSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Guests:', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                if (guests > 1) {
                  setState(() {
                    guests--;
                    _calculateTotalPrice();
                  });
                }
              },
            ),
            Text('$guests', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                setState(() {
                  guests++;
                  _calculateTotalPrice();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar Selector
            _buildDateSelector("Check-in", _checkInDate,
                (date) => setState(() => _checkInDate = date)),
            SizedBox(height: 10),
            _buildDateSelector("Check-out", _checkOutDate,
                (date) => setState(() => _checkOutDate = date)),
            SizedBox(height: 20),
            _buildGuestSelector(),
            SizedBox(height: 20),

            // Total Price
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Continue Button
            ElevatedButton(
              onPressed: _createBooking,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text("Continue", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
