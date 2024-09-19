import 'dart:io';
import 'package:hotel_sheraton_booking/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/userprovider.dart';
import '../../../utils/globalColors.dart';
import 'edit_profile_page.dart';

class ProfileScreen1 extends StatefulWidget {
  @override
  _ProfileScreen1State createState() => _ProfileScreen1State();
}

class _ProfileScreen1State extends State<ProfileScreen1> {
  File? _image;
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Profile Picture and Name
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: GlobalColors.primaryColor,
                  backgroundImage: user.profilePicturePath.isNotEmpty
                      ? NetworkImage(user.profilePicturePath)
                      : const AssetImage('Assets/logo.png') as ImageProvider,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Edit Profile screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UpdateProfileScreen()),
                        );
                      },
                      child: const Text(
                        'View and edit profile',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          decoration:
                              TextDecoration.underline, // Optional for emphasis
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Change Password
            _buildMenuOption(
              context,
              icon: Icons.lock,
              text: 'Change Password',
              onTap: () {
                // Add Change Password Screen
              },
            ),
            const SizedBox(height: 10),
            // Settings
            _buildMenuOption(
              context,
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                // Add Settings Screen
              },
            ),
            const SizedBox(height: 10),
            // Log Out
            _buildMenuOption(
              context,
              icon: Icons.logout,
              text: 'Log Out',
              color: Colors.red,
              onTap: () => auth.signOut(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context,
      {required IconData icon,
      required String text,
      required Function() onTap,
      Color color = Colors.black}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
    );
  }
}
