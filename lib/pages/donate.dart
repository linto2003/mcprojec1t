import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcproj/Providers/product.dart';
import 'package:mcproj/pages/search%20page.dart';
import 'package:mcproj/services/functions/firebaseFunctions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';

class Product {
  final String name;
  final String composition;
  final List<String> uses;
  final List<String> sideEffects;

  Product({
    required this.name,
    required this.composition,
    required this.uses,
    required this.sideEffects,
  });
}

class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    return _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate'),
      ),
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Text(
            'Capture the image of the\n medicine showing the expiry date',
            style: GoogleFonts.getFont('Poppins',
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            // Upload image to Firebase Storage
            final ref = FirebaseStorage.instance
                .ref()
                .child('images/${DateTime.now()}.png');
            await ref.putFile(File(image.path));

            // Get download URL
            final url = await ref.getDownloadURL();

            // Navigate to the new page with the image URL
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicineDetailsPage(imageUrl: url),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}

class MedicineDetailsPage extends StatefulWidget {
  final String imageUrl;

  const MedicineDetailsPage({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  _MedicineDetailsPageState createState() => _MedicineDetailsPageState();
}

class _MedicineDetailsPageState extends State<MedicineDetailsPage> {
  late TextEditingController _medicineNameController;
  late TextEditingController _expiryDateController;
  late TextEditingController _name;
  late TextEditingController _place;
  late TextEditingController _contact;
  late Product medicine;

  List<Product> _searchResults = [];
  bool _showList = false;

  @override
  void initState() {
    super.initState();
    _medicineNameController = TextEditingController();
    _expiryDateController = TextEditingController();
    _name = TextEditingController();
    _place = TextEditingController();
    _contact = TextEditingController();
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    super.dispose();
  }

  Future<void> _searchMedicine(String query) async {
    final response = await http.get(Uri.parse(
        'https://e556-103-117-185-167.ngrok-free.app/search?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Product> products = data.map((item) {
        return Product(
          name: item['name'] as String,
          composition: item['composition'] as String,
          uses: (item['uses'] as String)
              .replaceAll("[", "")
              .replaceAll("]", "")
              .split(", "),
          sideEffects: (item['side effects'] as String)
              .replaceAll("[", "")
              .replaceAll("]", "")
              .split(", "),
        );
      }).toList();

      setState(() {
        _searchResults = products;
        _showList = true; // Show the list when search results are available
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.imageUrl),
            TextField(
              controller: _medicineNameController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
              onChanged: (value) {
                _searchMedicine(value);
              },
            ),
            _showList
                ? Container(
                    height: 200, // Specify a fixed height for the ListView
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _medicineNameController.text =
                                  _searchResults[index].name;
                              _showList = false;
                              print(_showList);
                              medicine = _searchResults[index];
                              _searchResults =
                                  []; // Hide the list after selection
                            });
                          },
                          child: ListTile(
                            title: Text(_searchResults[index].name),
                          ),
                        );
                      },
                    ),
                  )
                : Column(
                    children: [
                      TextField(
                        controller: _expiryDateController,
                        decoration: InputDecoration(labelText: 'Expiry Date'),
                      ),
                      TextField(
                        controller: _name,
                        decoration: InputDecoration(labelText: 'Donor Name'),
                      ),
                      TextField(
                        controller: _place,
                        decoration:
                            InputDecoration(labelText: 'Place to Receive'),
                      ),
                      TextField(
                        controller: _contact,
                        decoration:
                            InputDecoration(labelText: 'Contact Details'),
                        keyboardType:
                            TextInputType.phone, // Set keyboard type to phone
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Retrieve the entered values
                          final medicineName = medicine.name;
                          final expiryDate = _expiryDateController.text;
                          final name = _name.text;
                          final place = _place.text;
                          final contact = _contact.text;

                          // Check if any of the fields are empty
                          if (medicineName.isEmpty ||
                              expiryDate.isEmpty ||
                              name.isEmpty ||
                              place.isEmpty ||
                              contact.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill in all fields')),
                            );
                            return;
                          }

                          if (!_validateContact(contact)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter a valid contact number')),
                            );
                            return;
                          }

                          // Save the data to Firestore
                          FirestoreServices.saveMed(
                            medicineName,
                            medicine.composition,
                            medicine.sideEffects as List<String>,
                            medicine.uses as List<String>,
                            expiryDate,
                            widget.imageUrl,
                            place,
                            name,
                            contact,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('You donated $medicineName')),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text('Save'),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

bool _validateContact(String contact) {
  // Remove any non-digit characters from the contact string
  final cleanedContact = contact;

  if (cleanedContact.length != 10) {
    print('not 10');
    return false;
  }

  return true;
}
