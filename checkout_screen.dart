import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isCashOnDelivery = true;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    // Validate form
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Get services and user data
    final cart = Provider.of<CartService>(context, listen: false);
    final firestoreService = FirestoreService();
    final authService = AuthService();
    final userId = authService.getCurrentUserId();

    // Check if user is logged in
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطأ: لم يتم العثور على المستخدم. الرجاء تسجيل الدخول مرة أخرى.')),
      );
      return;
    }

    // Prepare order data
    final orderData = {
      'userId': userId,
      'address': _addressController.text.trim(),
      'phone': _phoneController.text.trim(),
      'paymentMethod': 'الدفع عند الاستلام',
      'totalPrice': cart.totalPrice,
      'items': cart.items
          .map((item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'quantity': item.quantity,
                'price': item.product.price,
              })
          .toList(),
      'orderDate': Timestamp.now(),
      'status': 'قيد المراجعة', // Initial status
    };

    // Submit order to Firestore
    try {
      await firestoreService.addOrder(orderData);

      // Clear cart on success
      cart.clearCart();

      // Show confirmation dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false, // User must tap button to close
        builder: (ctx) => AlertDialog(
          title: const Text('تم استلام طلبك'),
          content: const Text('شكرًا لك! طلبك قيد المراجعة الآن.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                Navigator.of(context).popUntil(ModalRoute.withName('/home')); // Go back to home
              },
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show error message on failure
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إرسال الطلب: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الطلب'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('معلومات التوصيل', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'العنوان بالتفصيل',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال عنوانك';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال رقم هاتفك';
                  }
                  if (value.length < 10) {
                    return 'الرجاء إدخال رقم هاتف صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Text('طريقة الدفع', style: Theme.of(context).textTheme.titleLarge),
              CheckboxListTile(
                title: const Text('الدفع عند الاستلام'),
                value: _isCashOnDelivery,
                onChanged: (newValue) {
                  setState(() {
                    // For now, only this option is available
                    _isCashOnDelivery = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                ),
                child: const Text('تأكيد الطلب'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
