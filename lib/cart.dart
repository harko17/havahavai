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
      appBar: AppBar(title: Text('Cart Summary')),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (_, index) {
                  CartItem item = cartItems[index];
                  return ListTile(
                    leading: Image.network(item.product.imageUrl,
                        width: 50, height: 50),
                    title: Text(item.product.title),
                    subtitle: Text(
                        'Price: ₹${(item.product.discountedPrice * item.quantity).toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                cartNotifier.decrementQuantity(item)),
                        Text(item.quantity.toString()),
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                cartNotifier.incrementQuantity(item)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Text('Total: ₹${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
