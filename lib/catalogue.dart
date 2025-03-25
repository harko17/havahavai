import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'cart.dart';

class CataloguePage extends ConsumerStatefulWidget {
  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends ConsumerState<CataloguePage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final productsNotifier = ref.read(productsProvider.notifier);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        productsNotifier.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsNotifier = ref.watch(productsProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text('Catalogue'),
        centerTitle: true,
        actions: [
          Consumer(builder: (context, ref, _) {
            final cartItems = ref.watch(cartProvider);
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart,size: 30,),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage()),
                  ),
                ),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 3,
                    top: 5,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartItems.length.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: productsList(),
    );
  }

  Widget productsList() {
    return Consumer(builder: (context, ref, _) {
      final products = ref.watch(productsProvider);
      final cartNotifier = ref.watch(cartProvider.notifier);
      return GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.64,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (_, index) {
          Product product = products[index];
          return ProductCard(
            imageUrl: product.imageUrl,
            title: product.title,
            brand: product.brand,
            price: product.price,
            discountedPrice: product.discountedPrice,
            discountPercentage: product.discountPercentage,
            onAddToCart: () => cartNotifier.addToCart(product),
          );
        },
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String brand;
  final double price;
  final double discountedPrice;
  final double discountPercentage;
  final VoidCallback onAddToCart;

  const ProductCard({
    required this.imageUrl,
    required this.title,
    required this.brand,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: ElevatedButton(
                  onPressed: onAddToCart,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    elevation: 4,
                  ),
                  child: Text('Add'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(brand, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${price.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '₹${discountedPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${discountPercentage.toStringAsFixed(2)}% OFF',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}