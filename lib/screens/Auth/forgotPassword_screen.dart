import 'package:hotel_sheraton_booking/screens/Auth/VerificationCode_screen.dart';
import 'package:flutter/material.dart';
import '../../services/Auth.dart';
import '../../utils/custom_textfield.dart';
import '../../utils/globalColors.dart'; // Import global colors

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

  void submitEmail(BuildContext context) {
    final email = emailController.text;
    authService.forgotPassword(context: context, email: email);
    // Pass the email to the Verification Code screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationCodeScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Forgot Your Password?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GlobalColors.secondaryColor,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Enter your email address below to reset your password.",
              style: TextStyle(
                fontSize: 16,
                color: GlobalColors.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.email,
              iconColor: GlobalColors.primaryColor,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => submitEmail(context),
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
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
