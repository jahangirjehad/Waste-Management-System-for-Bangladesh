import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required bool isCreateUser,
    required String name,
    required String email,
    required String password,
    required String orgName,
    required String orgEmail,
    required String orgPhone,
    required String lat,
    required String long,
    File? profileImage,
  }) async {
    // Register the user with Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    if (isCreateUser) {
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'profileImage': profileImage?.path ?? '',
        'latitude': double.tryParse(lat) ?? 0.0,
        'longitude': double.tryParse(long) ?? 0.0,
        'registeredAt': DateTime.now(),
      });
    } else {
      await _firestore
          .collection('organizations')
          .doc(userCredential.user!.uid)
          .set({
        'orgName': orgName,
        'email': orgEmail,
        'phone': orgPhone,
        'latitude': double.tryParse(lat) ?? 0.0,
        'longitude': double.tryParse(long) ?? 0.0,
        'registeredAt': DateTime.now(),
      });
    }
  }
}
