import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcproj/auth/signUp.dart';
import 'package:mcproj/auth/widgets/textFeild.dart';
import 'package:mcproj/constants/const.dart';
import 'package:mcproj/pages/home.dart';

class LoginPage extends StatefulWidget {
  static const route = '/logIn';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Logged in user: ${userCredential.user!.email}');

      // Navigate to next screen or perform other actions upon successful login
      Navigator.pushReplacementNamed(context, HomePage.route);
    } catch (e) {
      print('Failed to sign in: $e');
      // Show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid email or password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png', // Replace 'background_image.jpg' with your image path
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  textFeild(
                    Controller: emailController,
                    labeltext: 'Email',
                    hinttext: 'Enter your email',
                    icon: Icons.email,
                    password: false,
                  ),
                  SizedBox(height: 20),
                  textFeild(
                    Controller: passwordController,
                    labeltext: 'Password',
                    hinttext: 'Enter your password',
                    icon: Icons.password,
                    password: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Red color
                      textStyle: TextStyle(fontSize: 20), // Font size 20
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.getFont('Poppins',
                          fontSize: 20, color: Constants.all_color),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, SignupPage.route);
                        },
                        child: Text(
                          'Not SignedUp ??',
                          style: GoogleFonts.getFont('Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
