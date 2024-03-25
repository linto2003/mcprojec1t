import 'dart:math';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcproj/constants/const.dart';
import 'package:mcproj/pages/medicine_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/logIn.dart';
import '../services/functions/locationService.dart';

late String lat;
late String long;

class HomePage extends StatefulWidget {
  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Uint8List _image;
  ImageProvider imageProvider = AssetImage('assets/linto.png');
  Position? userlocation;
  bool isLoading = false;

  void redirectToURL({required String query}) async {
    setState(() {
      isLoading = true;
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: Constants.all_color,
              ),
            );
          });
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) {
      //       return Scaffold(
      //         backgroundColor: Colors.transparent,
      //         body: Center(
      //           child: CircularProgressIndicator(
      //             color: greenColor,
      //           ),
      //         ),
      //       );
      //     }));
    });
    Position position = await determinePosition();
    setState(() {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      isLoading = false;
      Navigator.of(context).pop();
    });

    var url = Uri.parse(
        "https://www.google.com/maps/search/$query/@$lat,$long,15.25z?entry=ttu");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImageAndUpdateFirestore(imageBytes, user) async {
    try {
      // Existing code for storage reference and image upload
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${DateTime.now().millisecondsSinceEpoch}');
      await storageRef.putData(imageBytes);

      // Get download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Access user document (replace with your user ID logic)
      final firestore = FirebaseFirestore.instance;
      final userDoc = firestore.collection('users').doc(user?.uid);

      // Update Firestore with download URL
      await userDoc.update({
        'imageUrl': downloadUrl,
      });

      // Update state after successful upload (if applicable)
      setState(() {
        // ... your state updates
      });
    } catch (error) {
      // Handle errors here
      print(error.toString()); // Log the error for debugging
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void navigateToProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListPage()),
    );
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle sign out errors
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.all_color,
        title: Text(
          'MEDIGIVE',
          style: GoogleFonts.getFont('Poppins',
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        iconTheme:
            IconThemeData(color: Colors.white), // Change icon color to white
      ),
      drawer: Drawer(
        backgroundColor: Constants.all_color,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100, // Adjust this value to change the height
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Constants.all_color,
                ),
                child: Text(
                  'MEDIGIVE',
                  style: GoogleFonts.getFont('Poppins',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            /// Exp 7
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.all_color,
                ),
                child: GestureDetector(
                  onTap: () async {
                    // Get image from gallery
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    final user = FirebaseAuth.instance.currentUser;
                    if (image != null) {
                      // Read image bytes and update state
                      final imageBytes = await image.readAsBytes();
                      uploadImageAndUpdateFirestore(imageBytes, user);
                      setState(() {
                        print('image changes');
                        _image = imageBytes;
                        imageProvider = _image != null
                            ? MemoryImage(_image!) as ImageProvider
                            : AssetImage('assets/linto.png') as ImageProvider;
                      });
                    } else {
                      print("Image Null");
                    }
                  },
                  child: Container(
                      child: CircleAvatar(
                          radius: 80, backgroundImage: imageProvider)),
                ),
              ),
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Center(
                child: Text(
                  'Item 1',
                  style: GoogleFonts.getFont('Poppins',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              onTap: () {
                // Update the UI based on the item selected
                // Close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Center(
                child: Text(
                  'LogOut',
                  style: GoogleFonts.getFont('Poppins',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/homebg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Share Healing,\n'
                  ' Share Hope',
                  style: GoogleFonts.getFont('Poppins',
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 140,
                ),
                Text(
                  'Connecting kindness with \n'
                  'every medicine shared',
                  style: GoogleFonts.getFont('Poppins',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        image: 'assets/icon1.png',
                        text: 'Products',
                        onTap: navigateToProducts,
                      ),
                      Button(
                        image: 'assets/icon2.png',
                        text: 'DONATE',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                Button(
                  image: 'assets/icon3.png',
                  text: 'MEDICAL SHOPS / NGOS',
                  onTap: () {
                    redirectToURL(query: 'Medical shops');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Button extends StatefulWidget {
  const Button({
    required this.image,
    required this.text,
    required this.onTap, // Optional onTap callback
    super.key,
  });

  final String image;
  final String text;
  final void Function() onTap;
  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  // Optional onTap callback type
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Use the provided onTap callback if available
      child: Column(
        children: [
          Image.asset(
            widget.image,
            height: 95,
          ),
          Text(
            widget.text,
            style: GoogleFonts.getFont('Poppins',
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
