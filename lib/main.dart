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
  final String category;
  final String imageUrl;
  final double price;
  final double discountedPrice;
  final double discountPercentage;
  final double rating;
  final int popularity;
  final DateTime dateAdded;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.rating,
    required this.popularity,
    required this.dateAdded,
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

final cartProvider =
StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
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

  int _currentPage = 1;
  bool isLoading = false;
  final int _limit = 10;
  List<Product> allProducts = [];

  Future<void> fetchProducts() async {
    if (isLoading) return;
    isLoading = true;
    Response response = await Dio().get('https://dummyjson.com/products',
        queryParameters: {'limit': _limit, 'skip': (_currentPage - 1) * _limit});
    List data = response.data['products'];
    List<Product> newProducts = data.map((item) {
      double price = item['price'].toDouble();
      double discount = item['discountPercentage'].toDouble();
      double discountedPrice = price - (price * discount / 100);
      return Product(
        id: item['id'],
        title: item['title'],
        brand: item['brand'],
        category: item['category'],
        imageUrl: item['thumbnail'],
        price: price,
        discountedPrice: discountedPrice,
        discountPercentage: discount,
        rating: item['rating'] != null ? item['rating'].toDouble() : 0.0,
        popularity: item['stock'] ?? 0,
        dateAdded: DateTime.now(),
      );
    }).toList();
    allProducts = [...allProducts, ...newProducts];
    state = [...state, ...newProducts];
    isLoading = false;
    _currentPage++;
  }

  void applyFilters({
    String? searchQuery,
    List<String>? categories,
    List<String>? brands,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? minDiscount,
    String? sortOption,
  }) {
    List<Product> filteredProducts = allProducts;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.brand.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (categories != null && categories.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) => categories.contains(product.category))
          .toList();
    }

    if (brands != null && brands.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) => brands.contains(product.brand))
          .toList();
    }

    if (minPrice != null) {
      filteredProducts = filteredProducts
          .where((product) => product.discountedPrice >= minPrice)
          .toList();
    }

    if (maxPrice != null) {
      filteredProducts = filteredProducts
          .where((product) => product.discountedPrice <= maxPrice)
          .toList();
    }

    if (minRating != null) {
      filteredProducts = filteredProducts
          .where((product) => product.rating >= minRating)
          .toList();
    }

    if (minDiscount != null) {
      filteredProducts = filteredProducts
          .where((product) => product.discountPercentage >= minDiscount)
          .toList();
    }

    if (sortOption != null) {
      switch (sortOption) {
        case 'Price: Low to High':
          filteredProducts
              .sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
          break;
        case 'Price: High to Low':
          filteredProducts
              .sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
          break;
        case 'Popularity':
          filteredProducts.sort((b, a) => a.popularity.compareTo(b.popularity));
          break;
        case 'Rating: High to Low':
          filteredProducts.sort((b, a) => a.rating.compareTo(b.rating));
          break;
        case 'Newest First':
          filteredProducts.sort((b, a) => a.dateAdded.compareTo(b.dateAdded));
          break;
      }
    }

    state = filteredProducts;
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
      state = state.where((i) => i != item).toList();
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