import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havahavai/Extra/Sort_filter.dart';
import 'package:havahavai/main.dart';
import 'package:shimmer/shimmer.dart';

import 'main.dart';
import 'cart.dart';

class CataloguePage extends ConsumerStatefulWidget {
  @override
  _CataloguePageState createState() => _CataloguePageState();
}

class _CataloguePageState extends ConsumerState<CataloguePage> {
  int currentPage = 1;
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
    productsNotifier.fetchProducts(page: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final productsNotifier = ref.watch(productsProvider.notifier);
    final totalPages = productsNotifier.totalPages;

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
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () async {
                    setState(() {
                      currentPage--;
                    });
                    await ref.read(productsProvider.notifier).fetchProducts(
                      page: currentPage,
                      reset: true,
                    );
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
                  }
                      : null,
                  child: Text('Previous'),
                ),
                Text('Page $currentPage of $totalPages'),
                ElevatedButton(
                  onPressed: currentPage < totalPages
                      ? () async {
                    setState(() {
                      currentPage++;
                    });
                    await ref.read(productsProvider.notifier).fetchProducts(
                      page: currentPage,
                      reset: true,
                    );
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
                  }
                      : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productsList() {
    return Consumer(builder: (context, ref, _) {
      final products = ref.watch(productsProvider);
      final productsNotifier = ref.watch(productsProvider.notifier);
      final cartNotifier = ref.watch(cartProvider.notifier);

      if (productsNotifier.isLoading) {
        return GridView.builder(
          padding: EdgeInsets.all(8),
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.64,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 10, color: Colors.white),
                          SizedBox(height: 5),
                          Container(height: 10, width: 60, color: Colors.white),
                          SizedBox(height: 8),
                          Container(height: 10, width: 40, color: Colors.white),
                          SizedBox(height: 8),
                          Container(height: 10, width: 80, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      if (products.isEmpty) {
        return Center(child: Text('No products available.'));
      }

      return GridView.builder(
        padding: EdgeInsets.all(8),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.64,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
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
