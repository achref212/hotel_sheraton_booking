import 'package:flutter/material.dart';

class AddCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Card"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Holder Name
            TextField(
              decoration: InputDecoration(
                labelText: "Card Holder Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Card Number
            TextField(
              decoration: InputDecoration(
                labelText: "Card Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            // Expiry Date and CVV
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Expiry Date",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "CVV",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Spacer(),

            // Add Card Button
            ElevatedButton(
              onPressed: () {
                // Add logic to save the card info
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Card added successfully!")),
                );
                Navigator.pop(context); // Go back to payment selection
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
                  "Add New Card",
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
