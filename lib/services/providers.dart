import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershop/services/firebase_constant.dart';

User? currentUser = firebaseAuth.currentUser;

final screenIndexProvider = StateProvider((ref) => 0);

final allProductsStream = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection(productsCollection)
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final recentProductsStream = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance
      .collection(productsCollection)
      .orderBy('timestamp', descending: true)
      .snapshots();
});

final categoryProductsStream =
    StreamProvider.family<QuerySnapshot, String>((ref, category) {
  return firestore
      .collection(productsCollection)
      .where('category', isEqualTo: category)
      .snapshots();
});

final userCartStream = StreamProvider<Map<String, dynamic>?>((ref) {
  return FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(currentUser!.uid)
      .snapshots()
      .map((snapshot) => snapshot.data());
});

final userOrderStream = StreamProvider<Map<String, dynamic>?>((ref) {
  return FirebaseFirestore.instance
      .collection(ordersCollection)
      .doc(currentUser!.uid)
      .snapshots()
      .map((snapshot) => snapshot.data());
});
