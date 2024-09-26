import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/screens/room/room.dart';
import 'package:hotel_sheraton_booking/utils/constants.dart';

class PaymentConfirmationPage extends StatelessWidget {
  final double roomPrice;
  final int nights;
  final double totalPrice;
  final String roomName;
  final String roomimg;
  final String location;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;

  PaymentConfirmationPage({
    required this.roomPrice,
    required this.nights,
    required this.totalPrice,
    required this.roomName,
    required this.location,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.roomimg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Confirmation"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room and location details
            Row(
              children: [
                // Room Image
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${Constants.uri}/uploads/${roomimg.split("/").last}'), // Add your room image URL here
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                // Room Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
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
                      "\$$roomPrice / night",
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

            // Check-in, Check-out, and Guests
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem("Check in", checkInDate),
                _buildDetailItem("Check out", checkOutDate),
                _buildDetailItem("Guest", guests),
              ],
            ),
            SizedBox(height: 25),

            // Price Breakdown
            _buildPriceItem("$nights Nights", (roomPrice * nights) as double),
            Divider(),
            _buildPriceItem("Total", totalPrice, isBold: true),
            SizedBox(height: 25),

            // Payment method
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.orange),
              title: Text(
                "MasterCard •••• 4679",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: TextButton(
                onPressed: () {
                  // Logic to change payment method
                },
                child: Text("Change", style: TextStyle(color: Colors.green)),
              ),
            ),
            Spacer(),

            // Confirm Payment Button
            ElevatedButton(
              onPressed: () {
                // Logic for confirming the payment
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Payment successful!")),
                );

                // Navigate to RoomListScreen and clear all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoomListScreen(), // Replace with your RoomListScreen
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
                  "Confirm Payment",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build details for Check-in, Check-out, and Guests
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
