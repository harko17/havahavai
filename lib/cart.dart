import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.watch(cartProvider.notifier);
    double totalPrice = cartNotifier.getTotalPrice();

    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: Text('Cart Summary'),
        backgroundColor: Colors.pink[100],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, index) {
                CartItem item = cartItems[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.network(
                          item.product.imageUrl,
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                item.product.brand,
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '₹${item.product.discountedPrice.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    iconSize: 28,
                                    icon: Icon(Icons.remove),
                                    onPressed: () => cartNotifier.decrementQuantity(item),
                                  ),
                                  Text(item.quantity.toString()),
                                  IconButton(
                                    iconSize: 28,
                                    icon: Icon(Icons.add),
                                    onPressed: () => cartNotifier.incrementQuantity(item),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            height: 150,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Items: ${cartItems.length}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Amount Payable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.pink[700],
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Check Out',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
