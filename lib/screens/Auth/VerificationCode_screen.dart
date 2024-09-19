import 'package:hotel_sheraton_booking/screens/Auth/ChangePassword_screen.dart';
import 'package:flutter/material.dart';
import '../../services/Auth.dart';
import '../../utils/custom_textfield.dart';
import '../../utils/globalColors.dart'; // Import global colors

class VerificationCodeScreen extends StatelessWidget {
  final String email;

  VerificationCodeScreen({required this.email});

  final TextEditingController codeController = TextEditingController();
  final AuthService authService = AuthService();

  void verifyCode(BuildContext context) async {
    final code = codeController.text;
    final result = await authService.verifyCode(
        context: context, email: email, code: code);
    if (result == 200) {
      // Navigate to the Change Password screen if verification succeeds
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(),
        ),
      );
    } else {
      // Handle verification failure (e.g., show an error message)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Verification Failed"),
          content:
              Text("The verification code is incorrect. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Verification Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GlobalColors.secondaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Enter the verification code sent to $email.",
              style: TextStyle(
                fontSize: 16,
                color: GlobalColors.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: codeController,
              hintText: "Verification Code",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.code,
              iconColor: GlobalColors.primaryColor,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => verifyCode(context),
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
              child: Text("Verify Code"),
            ),
          ],
        ),
      ),
    );
  }
}
