import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> addOrder(Map<String, dynamic> orderData) async {
    try {
      await _db.collection('orders').add(orderData);
    } catch (e) {
      // Handle potential errors, e.g., by logging them
      developer.log('Error adding order: $e');
      rethrow;
    }
  }
}
