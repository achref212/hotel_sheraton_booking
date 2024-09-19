import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import '../../services/Auth.dart';
import '../../utils/custom_textfield.dart'; // Make sure this path matches the location of your CustomTextField file
import '../../utils/globalColors.dart'; // Assuming this contains your color scheme
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();

  void signupUser() {
    authService.signUpUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '104792978938-8osg03385fiif0h9n084j2raadlacgsv.apps.googleusercontent.com',
      scopes: ['email']);

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Send Google Sign-In data to the backend
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String? code = googleAuth.idToken;

        if (code != null) {
          await authService.sendGoogleSignInDataToBackend(code, context);
        }
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'Assets/logo.png',
              width: 85,
              height: 45,
            ),
            SizedBox(width: 10),
            Text(
              'Join Us Today',
              style: TextStyle(
                  color: GlobalColors.secondaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Fullname TextField with Icon
              CustomTextField(
                controller: nameController,
                hintText: 'Enter your name',
                borderColor: GlobalColors.primaryColor,
                focusedBorderColor: GlobalColors.secondaryColor,
                borderRadius: 8.0,
                prefixIcon: Icons.person, // Fullname icon
              ),
              const SizedBox(height: 24),
              // Email TextField with Icon
              CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
                borderColor: GlobalColors.primaryColor,
                focusedBorderColor: GlobalColors.secondaryColor,
                borderRadius: 8.0,
                prefixIcon: Icons.email, // Email icon
              ),
              const SizedBox(height: 24),
              // Password TextField with Icon
              CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                obscureText: true,
                borderColor: GlobalColors.primaryColor,
                focusedBorderColor: GlobalColors.secondaryColor,
                borderRadius: 8.0,
                prefixIcon: Icons.lock, // Password icon
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: signupUser,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(GlobalColors.buttonColor),
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50)),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(color: GlobalColors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Sign In",
                          style: TextStyle(color: GlobalColors.linkColor)),
                    ),
                    const Text("or continue with"),
                    const SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          buttonType: SocialLoginButtonType.google,
                          onPressed: () async {
                            // Perform Google Sign-In
                            try {
                              await _handleSignIn();
                            } catch (error) {
                              print('Error during Google Sign-In: $error');
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        SocialLoginButton(
                          buttonType: SocialLoginButtonType.github,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
