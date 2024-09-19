import 'package:flutter/material.dart';

import '../../models/activity_model.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final ActivityModel activity;

  ActivityDetailsScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(activity.imageUrl),
            SizedBox(height: 10),
            Text(
              activity.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              activity.location,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              activity.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '\$${activity.price} per person',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              'Max Participants: ${activity.maxParticipants}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Current Participants: ${activity.currentParticipants}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
