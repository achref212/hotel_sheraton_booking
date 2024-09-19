import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/models/user.dart';
import 'package:hotel_sheraton_booking/utils/constants.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    lastname: '',
    email: '',
    token: '',
    password: '',
    profilePicturePath: '',
    birthdate: '',
    role: 'user', // Assuming 'user' as default role
  );

  User get user => _user;

  void setUser(Map<String, dynamic> userMap) {
    _user = User.fromJson(userMap);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void setPasswordResetEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  void updateUserProfile(String birthdate, String jobTitle) {
    // Update the user's profile on the backend
    // Then update the local user object
    _user.birthdate = birthdate;
    notifyListeners();
  }

  Future<void> updateUser({
    required String name,
    required String email,
    required String lastname,
    required String birthdate,
    String? password,
    File? profileImage,
  }) async {
    try {
      // Prepare the request body
      var request = http.MultipartRequest(
          'PUT', Uri.parse('${Constants.uri}/users/${_user.id}'));

      // Add fields to the request
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['lastname'] = lastname;
      request.fields['birthdate'] = birthdate;
      if (password != null && password.isNotEmpty) {
        request.fields['password'] = password;
      }

      // If a profile image is provided, add it to the request
      if (profileImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', profileImage.path));
      }

      // Add token in headers for authentication
      request.headers['Authorization'] = 'Bearer ${_user.token}';

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // If the update is successful, parse the updated user information
        final responseBody = await response.stream.bytesToString();
        final updatedUserMap = jsonDecode(responseBody);

        // Update the local user object
        setUser(updatedUserMap);

        // Notify listeners to update the UI
        notifyListeners();
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }
}
