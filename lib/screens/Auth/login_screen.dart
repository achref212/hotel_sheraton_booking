import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/screens/Auth/signup_screen.dart';
import 'package:hotel_sheraton_booking/screens/Auth/forgotPassword_screen.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import '../../services/Auth.dart';
import '../../utils/custom_textfield.dart';
import '../../utils/globalColors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; // For toggling password visibility
  final AuthService authService = AuthService();
  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '104792978938-8osg03385fiif0h9n084j2raadlacgsv.apps.googleusercontent.com',
      scopes: ['email']);
  void loginUser() {
    authService.signInUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
    );
  }

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
    // Change status bar color to match the AppBar (optional)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: GlobalColors.primaryColor,
    ));

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
              'Welcome Back!',
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
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            // Use ConstrainedBox to provide bounded height constraints
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context)
                  .size
                  .height, // Min height to the size of the screen
            ),
            child: IntrinsicHeight(
              // Make sure the Column's height is bounded
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8),
                  Text(
                    "Let's sign you in.",
                    style: TextStyle(
                      fontSize: 16,
                      color: GlobalColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 48),
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.email,
                    iconColor: GlobalColors.primaryColor,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock,
                    iconColor: GlobalColors.primaryColor,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: GlobalColors.linkColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      primary: GlobalColors.buttonColor,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text("Log in"),
                  ),
                  SizedBox(height: 32),
                  Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: Text("Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: GlobalColors
                                .linkColor)), // Use global link color
                  ),
                  Text("or continue with"),
                  SizedBox(height: 16),
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
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
