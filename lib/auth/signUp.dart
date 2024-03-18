import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcproj/auth/widgets/textFeild.dart';
import 'package:mcproj/constants/const.dart';
import 'package:mcproj/services/functions/firebaseFunctions.dart';

import 'logIn.dart';

class SignupPage extends StatefulWidget {
  static const route = '/signUp';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void _signup() async {
    String email = emailController.text;
    String password = passwordController.text;
    String name = nameController.text;
    String phone = phoneController.text;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirestoreServices.saveUser(
          name, email, phone, userCredential.user!.uid);
      print('User registered: ${userCredential.user!.email}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      // Navigate to next screen or perform other actions upon successful signup
    } catch (e) {
      print('Failed to sign up: $e');
      print(e.toString());
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Signup Failed'),
              content: Text('Email Already Registered!!'),
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
      } else {
        // Show error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Signup Failed'),
              content: Text('Failed to create an account. Please try again.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    textFeild(
                        Controller: nameController,
                        labeltext: 'Name',
                        hinttext: 'Enter your name',
                        icon: Icons.person,
                        password: false),
                    SizedBox(height: 20),
                    textFeild(
                        Controller: phoneController,
                        labeltext: 'Phone Number',
                        hinttext: 'Enter your phone numebr',
                        icon: Icons.phone,
                        password: false),
                    SizedBox(height: 20),
                    textFeild(
                        Controller: emailController,
                        labeltext: 'Email',
                        hinttext: 'Enter valid email',
                        icon: Icons.email,
                        password: false),
                    SizedBox(height: 20),
                    textFeild(
                        Controller: passwordController,
                        labeltext: 'Password',
                        hinttext: 'Enter valid Password',
                        icon: Icons.password,
                        password: true),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Red color
                        textStyle: TextStyle(fontSize: 20), // Font size 20
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Signup',
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
                                context, LoginPage.route);
                          },
                          child: Text(
                            'Already SignedUp ??',
                            style: GoogleFonts.getFont('Poppins',
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
