import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String name, email, phoneNumber, city, uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'number': '+91' + phoneNumber,
      'city': city,
    });
  }

  static saveMed(
      String med_name,
      String comp,
      List<String> side,
      List<String> use,
      String date,
      String url,
      String place,
      String name,
      String contact) async {
    await FirebaseFirestore.instance.collection('donations').add({
      'med_name': med_name,
      'composition': comp,
      'side-effects': side,
      'uses': use,
      'expiry_date': date,
      'url': url,
      'place': place,
      'name': name,
      'contact': contact
    });
  }
}
