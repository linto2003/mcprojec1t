import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcproj/constants/const.dart';
import 'package:mcproj/pages/medicine_page.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _image;

  Future<void> _getImageFromLibrary() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = pickedImage;
      } else {
        print('No image selected.');
      }
    });
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
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.all_color,
                ),
                child: GestureDetector(
                    onTap: () async {},
                    child: Container(
                      child: _image != null
                          ? CircleAvatar(
                              radius: 80,
                              backgroundImage: MemoryImage(
                                  _image!) // Replace with your user's image
                              )
                          : const CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage(
                                  'assets/linto.png'), // Replace with your user's image
                            ),
                    )),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the UI based on the item selected
                // Close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the UI based on the item selected
                // Close the drawer
                Navigator.pop(context);
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        image: 'assets/icon1.png',
                        text: 'FIND MEDICINE',
                      ),
                      Button(
                        image: 'assets/icon2.png',
                        text: 'DONATE',
                      ),
                    ],
                  ),
                ),
                Button(
                  image: 'assets/icon3.png',
                  text: 'MEDICAL SHOPS / NGOS',
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
    super.key,
  });
  final String image;
  final String text;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductListPage()),
        );
      },
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
          )
        ],
      ),
    );
  }
}

class ImageEditorScreen extends StatelessWidget {
  final ImageProvider image;

  const ImageEditorScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Editor'),
      ),
      body: Center(
        child: Image(
          image: image,
        ),
      ),
// Add buttons or other widgets here for editing functionality (cropping, filters, etc.)
    );
  }
}
