import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: cart.items.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      'سلتك فارغة!',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'أضف بعض المنتجات لتبدأ التسوق.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, i) {
                        final item = cart.items[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                // In the future, you can use item.product.imageUrl here
                                child: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text('${item.product.price.toStringAsFixed(0)} LE'),
                                  ),
                                ),
                              ),
                              title: Text(item.product.name),
                              subtitle: Text('الكمية: ${item.quantity}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cart.removeItem(item.product.id);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('الإجمالي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Chip(
                              label: Text(
                                '${cart.totalPrice.toStringAsFixed(2)} جنيه',
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: cart.items.isEmpty ? null : () {
                              Navigator.of(context).pushNamed('/checkout');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              textStyle: const TextStyle(fontSize: 18, fontFamily: 'Cairo'),
                            ),
                            child: const Text('اطلب الآن'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

