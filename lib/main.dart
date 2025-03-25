import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'catalogue.dart';
import 'cart.dart';
import 'package:dio/dio.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class Product {
  final int id;
  final String title;
  final String brand;
  final String imageUrl;
  final double price;
  final double discountedPrice;
  final double discountPercentage;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

final productsProvider =
StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      debugShowCheckedModeBanner: false,
      home: CataloguePage(),
    );
  }
}

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super([]) {
    fetchProducts();
  }

  int currentPage = 1;
  int totalPages = 0;
  bool isLoading = false;

  Future<void> fetchProducts() async {
    if (isLoading) return;
    isLoading = true;
    Response response = await Dio().get('https://dummyjson.com/products',
        queryParameters: {'limit': 10, 'skip': (currentPage - 1) * 10});
    List data = response.data['products'];
    totalPages = (response.data['total'] / 10).ceil();
    List<Product> newProducts = data.map((item) {
      double price = item['price'].toDouble();
      double discount = item['discountPercentage'].toDouble();
      double discountedPrice = price - (price * discount / 100);
      return Product(
        id: item['id'],
        title: item['title'],
        brand: item['brand'],
        imageUrl: item['thumbnail'],
        price: price,
        discountedPrice: discountedPrice,
        discountPercentage: discount,
      );
    }).toList();
    state = [...state, ...newProducts];
    isLoading = false;
    currentPage++;
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    int index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      state[index].quantity++;
      state = [...state];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    state = [...state];
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      state = [...state];
    } else {
      state.remove(item);
      state = [...state];
    }
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in state) {
      total += item.product.discountedPrice * item.quantity;
    }
    return total;
  }
}