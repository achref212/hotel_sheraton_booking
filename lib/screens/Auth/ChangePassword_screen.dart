import 'package:hotel_sheraton_booking/screens/Auth/login_screen.dart';
import 'package:hotel_sheraton_booking/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/Auth.dart';
import '../../utils/custom_textfield.dart';
import '../../utils/globalColors.dart'; // Import global colors
import '../../providers/userprovider.dart';

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService authService = AuthService();

  void changePassword(BuildContext context) {
    final newPassword = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      showSnackBar(context, 'Passwords do not match');
      return;
    }

    // Get the email from the UserProvider
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.user.email;

    if (email.isEmpty) {
      showSnackBar(context, 'Email address not found');
      return;
    }

    authService.changePassword(
      context: context,
      email: email,
      newPassword: newPassword,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Change Your Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GlobalColors.secondaryColor,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: passwordController,
              hintText: "New Password",
              obscureText: true,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.lock,
              iconColor: GlobalColors.primaryColor,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              obscureText: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.lock,
              iconColor: GlobalColors.primaryColor,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => changePassword(context),
              style: ElevatedButton.styleFrom(
                primary: GlobalColors.buttonColor,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}
