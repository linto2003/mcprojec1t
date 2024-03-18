import 'package:flutter/material.dart';

import '../Providers/product.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Image.network(medicine.imageUrl), // Replace with actual image URL
            const SizedBox(height: 10.0), // Spacing between image and text
            // Name
            Text(
              medicine.medName,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0), // Spacing between elements
            // Description
            Text(medicine.desc),
            const SizedBox(height: 5.0),
            // Expiry Date
            Row(
              children: [
                const Text('Expiry Date: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(medicine.expirydate),
              ],
            ),
            const SizedBox(height: 5.0),
            // Donor Details
            Row(
              children: [
                const Text('Donor Details: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Linto'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
