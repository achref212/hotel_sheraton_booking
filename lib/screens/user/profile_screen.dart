import 'dart:io';
import 'package:hotel_sheraton_booking/screens/user/SettingsPage.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: GlobalColors.primaryColor,
                backgroundImage: user.profilePicturePath.isNotEmpty
                    ? NetworkImage(user.profilePicturePath)
                    : const AssetImage('Assets/logo.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),

            // Name and Location
            Text(
              user.name + " " + user.lastname,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),

            // Edit Profile Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UpdateProfileScreen()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: GlobalColors.buttonColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'View and Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Menu Options
            _buildMenuOption(
              context,
              icon: Icons.lock,
              text: 'Change Password',
              onTap: () {
                // Add Change Password Screen
              },
            ),
            const SizedBox(height: 10),
            _buildMenuOption(
              context,
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
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
