import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/screens/room/room.dart'; // Assuming this is the page where all rooms or activities are listed
import 'package:hotel_sheraton_booking/utils/constants.dart';

class ReservationConfirmationPage extends StatelessWidget {
  final int activityPrice;
  final int guests;
  final double totalPrice;
  final String activityName;
  final String activityImg;
  final String location;
  final DateTime reservationDate;

  ReservationConfirmationPage({
    required this.activityPrice,
    required this.guests,
    required this.totalPrice,
    required this.activityName,
    required this.location,
    required this.reservationDate,
    required this.activityImg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation Confirmation"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity and location details
            Row(
              children: [
                // Activity Image
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${Constants.uri}/uploads/${activityImg.split("/").last}'), // Add your activity image URL here
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                // Activity Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activityName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      location,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "\$$activityPrice / guest",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),

            // Reservation Date and Guests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem("Reservation Date", reservationDate),
                _buildDetailItem("Guests", guests),
              ],
            ),
            SizedBox(height: 25),

            // Price Breakdown
            _buildPriceItem("Guests", (activityPrice * guests).toDouble()),
            Divider(),
            _buildPriceItem("Total", totalPrice, isBold: true),
            SizedBox(height: 25),

            Spacer(),

            // Confirm Reservation Button
            ElevatedButton(
              onPressed: () {
                // Logic for confirming the reservation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Reservation successful!")),
                );

                // Navigate to RoomListScreen or ActivityListScreen and clear all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoomListScreen(), // Replace with your RoomListScreen or ActivityListScreen
                  ),
                  (Route<dynamic> route) => false, // This clears the back stack
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  "Confirm Reservation",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build details for Reservation Date and Guests
  Widget _buildDetailItem(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 4),
        value is DateTime
            ? Text(
                "${value.day}/${value.month}/${value.year}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : Text(
                value.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ],
    );
  }

  // Helper method to build price breakdown items
  Widget _buildPriceItem(String title, double price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("\$${price.toStringAsFixed(2)}",
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
