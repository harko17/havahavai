import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Extra/Sort_filter.dart';
import 'main.dart';
import 'cart.dart';

class CataloguePage extends ConsumerStatefulWidget {
  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends ConsumerState<CataloguePage> {
  ScrollController _scrollController = ScrollController();

  List<String> selectedCategories = [];
  List<String> selectedBrands = [];
  double? minPrice;
  double? maxPrice;
  double? minRating;
  double? minDiscount;
  String selectedSortOption = 'Popularity';

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final productsNotifier = ref.read(productsProvider.notifier);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !productsNotifier.isLoading) {
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
                  icon: Icon(Icons.shopping_cart, size: 30),
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
      body: Column(
        children: [
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  ref.read(productsProvider.notifier).applyFilters(
                    searchQuery: searchQuery,
                    categories: selectedCategories,
                    brands: selectedBrands,
                    minPrice: minPrice,
                    maxPrice: maxPrice,
                    minRating: minRating,
                    minDiscount: minDiscount,
                    sortOption: selectedSortOption,
                  );
                });
              },
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    onPressed: () {
                      showFilterBottomSheet();
                    },
                    icon: Icon(Icons.filter_list),
                    label: Text('Filter'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    onPressed: () {
                      showSortOptions();
                    },
                    icon: Icon(Icons.sort),
                    label: Text('Sort'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: productsList(),
          ),
        ],
      ),
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

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterOptions(
          selectedCategories: selectedCategories,
          selectedBrands: selectedBrands,
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: minRating,
          minDiscount: minDiscount,
          onApply: ({
            required List<String> categories,
            required List<String> brands,
            required double? minPriceValue,
            required double? maxPriceValue,
            required double? minRatingValue,
            required double? minDiscountValue,
          }) {
            setState(() {
              selectedCategories = categories;
              selectedBrands = brands;
              minPrice = minPriceValue;
              maxPrice = maxPriceValue;
              minRating = minRatingValue;
              minDiscount = minDiscountValue;
              ref.read(productsProvider.notifier).applyFilters(
                searchQuery: searchQuery,
                categories: selectedCategories,
                brands: selectedBrands,
                minPrice: minPrice,
                maxPrice: maxPrice,
                minRating: minRating,
                minDiscount: minDiscount,
                sortOption: selectedSortOption,
              );
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SortOptions(
          selectedOption: selectedSortOption,
          onSelect: (option) {
            setState(() {
              selectedSortOption = option;
              ref.read(productsProvider.notifier).applyFilters(
                searchQuery: searchQuery,
                categories: selectedCategories,
                brands: selectedBrands,
                minPrice: minPrice,
                maxPrice: maxPrice,
                minRating: minRating,
                minDiscount: minDiscount,
                sortOption: selectedSortOption,
              );
            });
            Navigator.pop(context);
          },
        );
      },
    );
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                  child: Image.network(
                    imageUrl,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,
                      elevation: 2,
                    ),
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
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