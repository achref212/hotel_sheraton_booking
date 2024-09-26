import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/screens/activity/Reservation/reservation.dart';
import 'package:hotel_sheraton_booking/utils/constants.dart';
import 'package:hotel_sheraton_booking/utils/globalColors.dart';
import 'package:provider/provider.dart';
import '../../../providers/userprovider.dart';
import '../../models/activity_model.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final ActivityModel activity;

  ActivityDetailsScreen({required this.activity});

  @override
  _ActivityDetailsScreenState createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Initialize the favorite status based on the activity model
    isFavorite = widget.activity.isFavorite;
  }

  // Function to toggle favorite status
  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.activity.isFavorite = isFavorite;
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
          'Activity Details',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Image in a Card
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    '${Constants.uri}/uploads/${widget.activity.imagePath.split("/").last}',
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

            // Activity Title and Favorite Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.activity.name,
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

            // Activity Details Section
            Text(
              'Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.activity.description,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),

            // Facilities Section
            Text(
              'Facilities',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling
              children: [
                _buildFacilityIcon(Icons.pool, 'Swimming Pool'),
                _buildFacilityIcon(Icons.wifi, 'WiFi'),
                _buildFacilityIcon(Icons.restaurant, 'Restaurant'),
                _buildFacilityIcon(Icons.local_parking, 'Parking'),
                _buildFacilityIcon(Icons.meeting_room, 'Meeting Room'),
                _buildFacilityIcon(Icons.elevator, 'Elevator'),
                _buildFacilityIcon(Icons.fitness_center, 'Fitness Center'),
                _buildFacilityIcon(Icons.access_time, '24-hours Open'),
              ],
            ),
            SizedBox(height: 20),

            // Activity Price and Book Now Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.activity.price} per person',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Reservation Page and pass userId and activityId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationPage(
                          userId: userId, // Pass the userId from provider
                          activityId: widget.activity.id,
                          activityPrice: widget.activity.price,
                          activity:
                              widget.activity, // Pass the activity details
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
                    'Reserve Now',
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

  // Widget for building facility icon and text
  Widget _buildFacilityIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.green),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
