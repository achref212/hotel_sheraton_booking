import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/models/room_model.dart';
import 'package:hotel_sheraton_booking/screens/room/Booking/AddCardPage.dart';
import 'package:hotel_sheraton_booking/screens/room/Booking/PaymentConfirmationPage.dart';

class PaymentPage extends StatefulWidget {
  final double totalPrice;
  final RoomModel room;
  final int nights;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;

  PaymentPage({
    required this.totalPrice,
    required this.room,
    required this.nights,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = "Paypal"; // Default selected method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Methods"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select a payment method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Payment Method: Paypal
            ListTile(
              leading: Icon(Icons.payment, color: Colors.blue),
              title: Text("Paypal"),
              trailing: Radio(
                value: "Paypal",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value.toString();
                  });
                },
              ),
            ),

            // Payment Method: Google Pay
            ListTile(
              leading: Icon(Icons.payment, color: Colors.red),
              title: Text("Google Pay"),
              trailing: Radio(
                value: "Google Pay",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value.toString();
                  });
                },
              ),
            ),

            // Payment Method: Apple Pay
            ListTile(
              leading: Icon(Icons.payment, color: Colors.black),
              title: Text("Apple Pay"),
              trailing: Radio(
                value: "Apple Pay",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value.toString();
                  });
                },
              ),
            ),

            // Debit/Credit Card option
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.green),
              title: Text("Pay with Debit/Credit Card"),
              trailing: Radio(
                value: "Card",
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value.toString();
                  });
                },
              ),
            ),

            Spacer(),

            // Continue button
            ElevatedButton(
              onPressed: () {
                // Navigate to confirmation or card adding logic based on selection
                if (selectedPaymentMethod == "Card") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCardPage()),
                  );
                } else {
                  // Proceed to confirmation page with all the required parameters
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentConfirmationPage(
                        roomPrice: widget.room.price,
                        totalPrice: widget.totalPrice,
                        nights: widget.nights,
                        roomName: widget.room.name,
                        location: widget.room.location,
                        checkInDate: widget.checkInDate,
                        checkOutDate: widget.checkOutDate,
                        guests: widget.guests,
                        roomimg: widget.room.imagePath,
                      ),
                    ),
                  );
                }
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
                  "Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
