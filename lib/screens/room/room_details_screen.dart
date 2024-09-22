import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/screens/room/Booking/BookingPage.dart';
import 'package:hotel_sheraton_booking/utils/constants.dart';
import 'package:hotel_sheraton_booking/utils/globalColors.dart';
import 'package:provider/provider.dart'; // To use the UserProvider
import '../../../providers/userprovider.dart'; // Import your UserProvider
import '../../models/room_model.dart';

class RoomDetailsScreen extends StatefulWidget {
  final RoomModel room;

  RoomDetailsScreen({required this.room});

  @override
  _RoomDetailsScreenState createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Initialize the favorite status based on the room model
    isFavorite = widget.room.isFavorite;
  }

  // Function to toggle favorite status
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.room.isFavorite = isFavorite;
      // You can also implement logic to save the favorite status in the database or backend.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the user ID from the provider
    var userId = Provider.of<UserProvider>(context, listen: false).user.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Room Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image in a Card
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    '${Constants.uri}/uploads/${widget.room.imagePath.split("/").last}',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error,
                          size: 100, color: Colors.red); // Handle error
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between the image and text

            // Room Title and Favorite Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.room.location,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 28,
                  ),
                  onPressed: _toggleFavorite, // Toggle favorite on click
                ),
              ],
            ),
            SizedBox(height: 15),

            // Room Details Section
            Text(
              'Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.room.description,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),

            // Room Price and Book Now Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.room.price} per night',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Booking Page and pass userId and roomId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          userId: userId, // Pass the userId from provider
                          roomId:
                              widget.room.id, // Pass the roomId from the room
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: GlobalColors.buttonColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Book Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
