import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/models/activity_model.dart';
import 'package:hotel_sheraton_booking/screens/activity/Reservation/ReservationConfirmationPage.dart';
import 'package:intl/intl.dart';
import 'package:hotel_sheraton_booking/models/reservation_model.dart';
import 'package:hotel_sheraton_booking/services/reservation_service.dart';

class ReservationPage extends StatefulWidget {
  final String userId;
  final String activityId;
  final int activityPrice;
  final ActivityModel activity;

  ReservationPage({
    required this.userId,
    required this.activityId,
    required this.activityPrice,
    required this.activity,
  });

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final ReservationService reservationService = ReservationService();
  DateTime? _reservationDate;
  int guests = 1;
  String reservationStatus = "pending";
  double totalPrice = 0;

  // Calculate total price based on guests and activity price
  void _calculateTotalPrice() {
    setState(() {
      totalPrice = widget.activityPrice.toDouble() * guests;
    });
  }

  // Function to create reservation
  Future<void> _createReservation() async {
    if (_reservationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a reservation date.")),
      );
      return;
    }

    try {
      ReservationModel reservation = ReservationModel(
        userId: widget.userId,
        activityId: widget.activityId,
        reservationDate: _reservationDate!,
        guests: guests,
        status: reservationStatus,
      );

      ReservationModel newReservation =
          await reservationService.createReservation(reservation);

      if (newReservation.id!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reservation created successfully!")),
        );

        // Navigate to ReservationConfirmationPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationConfirmationPage(
              activityPrice: widget.activityPrice,
              guests: guests,
              totalPrice: totalPrice,
              activityName: widget.activity.name,
              location: widget.activity.location,
              reservationDate: _reservationDate!,
              activityImg: widget.activity.imagePath,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create reservation. Please try again."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

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
      appBar: AppBar(title: Text("Reservation Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDateSelector("Reservation Date", _reservationDate,
                (date) => setState(() => _reservationDate = date)),
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
              onPressed: _createReservation,
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
