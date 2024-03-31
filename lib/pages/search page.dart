import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mcproj/pages/donate.dart';
import 'package:mcproj/pages/med_details.dart';
import 'package:shimmer/shimmer.dart';

class Donation {
  final String url;
  final String? medicineName;
  final String? comp;
  final List<dynamic>? uses;
  final List<dynamic>? side;
  final String? expiryDate;
  final String? donorName;
  final String? placeToReceive;
  final String? contactDetails;

  Donation({
    required this.url,
    this.medicineName,
    this.comp,
    this.uses,
    this.side,
    this.expiryDate,
    this.donorName,
    this.placeToReceive,
    this.contactDetails,
  });

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      url: map['url'] ?? '',
      medicineName: map['med_name'] ?? '',
      comp: map['composition'] ?? '',
      uses: map['uses'] ?? '',
      side: map['side-effects'] ?? '',
      expiryDate: map['expiry_date'] ?? '',
      donorName: map['name'] ?? '',
      placeToReceive: map['place'] ?? '',
      contactDetails: map['contact'] ?? '',
    );
  }
}

class MedicineSearchPage extends StatefulWidget {
  @override
  State<MedicineSearchPage> createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Donations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('donations').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<Donation> donations = snapshot.data!.docs.map((doc) {
            return Donation.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              return _buildDonationTile(donations[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Placeholder for shimmer effect
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(
              width: double.infinity,
              height: 24.0,
              color: Colors.white,
            ),
            subtitle: Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDonationTile(Donation donation) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          print(donation.comp);
          print(donation.uses?.join('\n'));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MedicineCard(medicine: donation)),
          );
        },
        child: ListTile(
          leading: Image.network(donation.url),
          title: Text(
            donation.medicineName ?? 'N/A',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Expiry Date: ${donation.expiryDate ?? "N/A"}',
            style: TextStyle(fontSize: 16.0),
          ),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
