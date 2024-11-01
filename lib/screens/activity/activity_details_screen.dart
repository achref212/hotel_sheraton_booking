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
    isFavorite = widget.activity.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.activity.isFavorite = isFavorite;
      // Add logic here to save favorite status if needed
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      return Icon(Icons.error, size: 100, color: Colors.red);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

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
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
            SizedBox(height: 15),

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

            Text(
              'Key Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // New key information section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKeyInfoRow(
                    Icons.location_on, 'Location', widget.activity.location),
                _buildKeyInfoRow(Icons.person, 'Max Participants',
                    '${widget.activity.maxParticipants}'),
                _buildKeyInfoRow(Icons.people, 'Current Participants',
                    '${widget.activity.currentParticipants}'),
              ],
            ),
            SizedBox(height: 20),

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationPage(
                          userId: userId,
                          activityId: widget.activity.id,
                          activityPrice: widget.activity.price,
                          activity: widget.activity,
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

  // Widget for displaying key information rows
  Widget _buildKeyInfoRow(IconData icon, String label, String info) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blueAccent),
        SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          info,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
