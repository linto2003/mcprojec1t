import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:mcproj/pages/search%20page.dart';

import '../Providers/product.dart';

class MedicineCard extends StatefulWidget {
  final Donation medicine;

  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Add elevation for a card-like effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Image.network(
              widget.medicine.url,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10.0), // Spacing between image and text
            // Name
            Text(
              widget.medicine.medicineName ?? 'N/A',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5.0), // Spacing between elements
            Divider(), // Add a divider
            // Composition
            Text(
              'Composition: ${widget.medicine.comp ?? 'N/A'}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(), // Add a divider
            // Uses
            Text(
              'Uses: ${widget.medicine.uses != null ? widget.medicine.uses!.join(', ') : 'N/A'}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(), // Add a divider
            // Expiry Date
            Text(
              'Expiry Date: ${widget.medicine.expiryDate ?? 'N/A'}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(), // Add a divider
            // Donor Name
            Text(
              'Donor Name: ${widget.medicine.donorName ?? 'N/A'}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(), // Add a divider
            // Place to Receive
            Text(
              'Place to Receive: ${widget.medicine.placeToReceive ?? 'N/A'}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(), // Add a divider
            // Contact Details
            Text(
              'Contact Details: ${widget.medicine.contactDetails ?? 'N/A'}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
