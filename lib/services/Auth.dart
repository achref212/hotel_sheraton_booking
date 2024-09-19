import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/userprovider.dart';
import '../screens/main_screen.dart';
import '../screens/Auth/signup_screen.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      Uri uri = Uri.parse('${Constants.uri}/signup');
      http.Response res = await http.post(
        uri,
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8"
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
              (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/signin'),
        // alternate method to do this M2
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8"
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          userProvider.setUser(jsonDecode(res.body)); // Pass decoded JSON map

          await prefs.setString('token', jsonDecode(res.body)['token']);

          navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
              (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        prefs.setString('token', '');
      }
      var tokenRes = await http.get(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
          'Authorization': "Bearer $token"
        },
      );

      var body = jsonDecode(tokenRes.body);
      print(body); // Debug print the entire body

      var response = body["valid"];
      print(response);

      if (response == true && body["user"] != null) {
        // Check if response is true and user is not null
        prefs.setString('token', token!);

        var userMap = body as Map<String, dynamic>;
        print("User Data: $userMap"); // Debug print the user data

        userProvider.setUser(userMap); // Pass the user data map
      } else {
        print("User data is null or response is not true.");
      }
    } catch (e) {
      print(e.toString());
      //showSnackBar(context, e.toString());
    }
  }

  void signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignupScreen()),
      (Route<dynamic> route) => false, // Remove all routes below
    );
  }

  void forgotPassword(
      {required BuildContext context, required String email}) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      // Set the email in the UserProvider
      userProvider.setPasswordResetEmail(email);

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/forgot_password'),
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Password reset email sent successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<int> verifyCode(
      {required BuildContext context,
      required String code,
      required String email}) async {
    try {
      // Get the email from the UserProvider
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      email = userProvider.user.email;
      if (email.isEmpty) {
        showSnackBar(context, 'Email address not found');
        return 400; // Return 400 if email is empty
      }

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/verify_code'),
        body: jsonEncode({'email': email, 'code': code}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );

      if (res.statusCode == 200) {
        showSnackBar(context, 'Verification code is valid');
        return 200; // Return 200 if verification is successful
      } else {
        return 400; // Return 400 if verification fails
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return 400; // Return 400 if an error occurs
    }
  }

  void changePassword(
      {required BuildContext context,
      required String newPassword,
      required String email}) async {
    try {
      // Get the email from the UserProvider
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      email = userProvider.user.email;
      if (email.isEmpty) {
        showSnackBar(context, 'Email address not found');
        return;
      }

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/reset_password'),
        body: jsonEncode({'email': email, 'new_password': newPassword}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Password successfully changed');
          // Navigate to login screen or perform desired action
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void setPassword(
      {required BuildContext context,
      required String newPassword,
      required String email}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/set-password'),
        body: jsonEncode({'email': email, 'password': newPassword}),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
      );
      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Password successfully changed');
          // Navigate to login screen or perform desired action
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> sendGoogleSignInDataToBackend(
      String code, BuildContext context) async {
    final Uri uri = Uri.parse('${Constants.uri}/google-sign-in');
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'code': code}),
    );

    if (response.statusCode == 200) {
      print('Google Sign-In data sent to backend endpoint successfully');
      final responseBody = json.decode(response.body);

      // Directly use the decoded JSON if it matches your expected structure
      if (responseBody != null && responseBody is Map<String, dynamic>) {
        print(responseBody);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        userProvider.setUser(responseBody); // Pass decoded JSON map

        await prefs.setString('token', responseBody['token']);
        // Store the token securely
        await prefs.setString('x-auth-token', responseBody['token']);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      } else {
        print("Invalid response format received.");
      }
    } else {
      print(
          'Error sending Google Sign-In data to backend: ${response.statusCode}');
    }
  }
}
