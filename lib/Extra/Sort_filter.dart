import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class FilterOptions extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedBrands;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final double? minDiscount;
  final Function({
  required List<String> categories,
  required List<String> brands,
  required double? minPriceValue,
  required double? maxPriceValue,
  required double? minRatingValue,
  required double? minDiscountValue,
  }) onApply;

  FilterOptions({
    required this.selectedCategories,
    required this.selectedBrands,
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.minDiscount,
    required this.onApply,
  });

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  List<String> tempSelectedCategories = [];
  List<String> tempSelectedBrands = [];
  double? tempMinPrice;
  double? tempMaxPrice;
  double? tempMinRating;
  double? tempMinDiscount;
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController minRatingController = TextEditingController();
  TextEditingController minDiscountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tempSelectedCategories = List.from(widget.selectedCategories);
    tempSelectedBrands = List.from(widget.selectedBrands);
    tempMinPrice = widget.minPrice;
    tempMaxPrice = widget.maxPrice;
    tempMinRating = widget.minRating;
    tempMinDiscount = widget.minDiscount;
    if (tempMinPrice != null) minPriceController.text = tempMinPrice.toString();
    if (tempMaxPrice != null) maxPriceController.text = tempMaxPrice.toString();
    if (tempMinRating != null) minRatingController.text = tempMinRating.toString();
    if (tempMinDiscount != null) minDiscountController.text = tempMinDiscount.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'smartphones',
      'laptops',
      'fragrances',
      'skincare',
      'groceries',
      'home-decoration'
    ];
    List<String> brands = [
      'Apple',
      'Samsung',
      'Huawei',
      'Sony',
      'LG',
      'OPPO',
      'Microsoft Surface',
      'Infinix',
      'HP Pavilion'
    ];
    return Container(
      padding: EdgeInsets.all(16),
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: [
                Divider(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExpansionTile(
                    title: Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                    children: categories.map((category) {
                      return CheckboxListTile(
                        title: Text(category),
                        value: tempSelectedCategories.contains(category),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              tempSelectedCategories.add(category);
                            } else {
                              tempSelectedCategories.remove(category);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExpansionTile(
                    title: Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
                    children: brands.map((brand) {
                      return CheckboxListTile(
                        title: Text(brand),
                        value: tempSelectedBrands.contains(brand),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              tempSelectedBrands.add(brand);
                            } else {
                              tempSelectedBrands.remove(brand);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: minPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: maxPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Max',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        controller: minRatingController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'e.g., 4.0',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minimum Discount (%)', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        controller: minDiscountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'e.g., 10',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    categories: tempSelectedCategories,
                    brands: tempSelectedBrands,
                    minPriceValue: double.tryParse(minPriceController.text),
                    maxPriceValue: double.tryParse(maxPriceController.text),
                    minRatingValue: double.tryParse(minRatingController.text),
                    minDiscountValue: double.tryParse(minDiscountController.text),
                  );
                },
                child: Text('Apply'),
              ),
              SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SortOptions extends StatelessWidget {
  final String selectedOption;
  final Function(String) onSelect;

  SortOptions({required this.selectedOption, required this.onSelect});

  final List<String> sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Popularity',
    'Rating: High to Low',
    'Newest First'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort By', style: TextStyle(fontSize: 18)),
          Expanded(
            child: ListView(
              children: sortOptions.map((option) {
                return RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    onSelect(value as String);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
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