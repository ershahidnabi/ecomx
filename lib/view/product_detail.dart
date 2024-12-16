import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(int) onQuantityChange;

  const ProductDetail({
    required this.product,
    required this.onQuantityChange,
    super.key,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.product['quantity']; // Initial quantity from passed data
  }

  void updateQuantity(int change) {
    setState(() {
      quantity = (quantity + change)
          .clamp(0, 99); // Ensure quantity stays between 0 and 99
      widget.onQuantityChange(change); // Update quantity in HomeScreen as well
    });
  }

  // Method to add the product to the cart (similar to HomeScreen)
  void addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];
    if (!cart.contains(widget.product['name'])) {
      cart.add(
          widget.product['name']); // Add product to cart if not already present
      await prefs.setStringList('cart', cart);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.product['name']} added to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.product['name']),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                widget.product['image'],
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product['price'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => updateQuantity(-1),
                  icon: const Icon(Icons.remove),
                  iconSize: 32,
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => updateQuantity(1),
                  icon: const Icon(Icons.add),
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add product to cart
                addToCart();
                Navigator.pop(context); // Go back to the HomeScreen
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
