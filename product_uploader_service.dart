import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class ProductUploaderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> _productsToUpload = [
    // خلطات الرز
    {'name': 'توابل ارز الكبسة (البسمتي)', 'price': 500, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'توابل المحاشي', 'price': 500, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    // صوص البودر
    {'name': 'صوص البشاميل', 'price': 440, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'صوص الديمي جلاس', 'price': 650, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    // توابل المرققات
    {'name': 'مرقة الدجاج', 'price': 410, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'مرقة اللحم', 'price': 410, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'مرقة اللحم الضأني', 'price': 410, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'مرقة الخضار', 'price': 410, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    // أطعم ونكهات
    {'name': 'طعم الجبنة', 'price': 440, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'طعم الجبنة المتبلة', 'price': 440, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'طعم الفراخ', 'price': 420, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'طعم الكباب', 'price': 420, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'طعم الكاتشب', 'price': 410, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'طعم الشطة والليمون', 'price': 410, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    // التوابل الأساسية
    {'name': 'فلفل أسود حصى', 'price': 650, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'فلفل أسود ناعم', 'price': 650, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'كمون حصى', 'price': 650, 'description': 'لكل كيلوجرام', 'imageUrl': ''},
    {'name': 'كمون ناعم', 'price': 650, 'description': 'لكل كيلوجرام', 'imageUrl': ''},

    // شکاير اوزان 2 كيلو
    {'name': 'بابريكا (عادية) - شكارة 2 كيلو', 'price': 400, 'description': 'سعر الشكارة 2 كيلو', 'imageUrl': ''},
    {'name': 'شطة سوداني - شكارة 2 كيلو', 'price': 550, 'description': 'سعر الشكارة 2 كيلو', 'imageUrl': ''},
    {'name': 'كزبره بلدي - شكارة 2 كيلو', 'price': 450, 'description': 'سعر الشكارة 2 كيلو', 'imageUrl': ''},
  ];

  Future<void> uploadProducts() async {
    final collectionRef = _db.collection('products');
    final batch = _db.batch();

    log('Starting to upload products...');

    for (final productData in _productsToUpload) {
      final docRef = collectionRef.doc();
      batch.set(docRef, productData);
    }

    try {
      await batch.commit();
      log('Successfully uploaded ${_productsToUpload.length} products.');
    } catch (e) {
      log('Error uploading products: $e');
      rethrow;
    }
  }

  Future<void> deleteAllProducts() async {
    final collectionRef = _db.collection('products');
    final batch = _db.batch();

    log('Starting to delete all products...');

    try {
      final snapshot = await collectionRef.get();
      if (snapshot.docs.isEmpty) {
        log('No products to delete.');
        return;
      }

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      log('Successfully deleted ${snapshot.docs.length} products.');
    } catch (e) {
      log('Error deleting products: $e');
      rethrow;
    }
  }
}
