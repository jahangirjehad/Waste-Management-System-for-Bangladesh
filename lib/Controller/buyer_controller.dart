import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/buyer_model.dart';

class BuyerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Buyer?> fetchBuyerProfile(String userEmail) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userEmail).get();
      if (snapshot.exists && snapshot.data() != null) {
        return Buyer.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Buyer not found');
      }
    } catch (error) {
      throw Exception('Failed to fetch buyer profile: $error');
    }
  }
}
