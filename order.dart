import 'product.dart';

class Order {
  final String id;
  final List<Product> products;
  final String userId;
  final String status;
  final String paymentMethod;
  final DateTime date;

  Order({
    required this.id,
    required this.products,
    required this.userId,
    required this.status,
    required this.paymentMethod,
    required this.date,
  });
}
