import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_detail.dart'; // Import the ProductDetail widget

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(int, int) onQuantityUpdate;
  final VoidCallback? onCartCleared;

  const CartScreen({
    required this.products,
    required this.onQuantityUpdate,
    this.onCartCleared,
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    _loadCartState(); // Load saved cart state
  }

  // Checks if the cart is empty
  bool get isCartEmpty {
    return widget.products.every((product) => product['quantity'] <= 0);
  }

  Future<void> _saveCartState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartData = widget.products
        .map((product) => '${product['name']}:${product['quantity']}')
        .toList();
    await prefs.setStringList('cartState', cartData);
  }

  Future<void> _loadCartState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartData = prefs.getStringList('cartState') ?? [];
    setState(() {
      for (String data in cartData) {
        List<String> productData = data.split(':');
        String productName = productData[0];
        int quantity = int.parse(productData[1]);

        for (var product in widget.products) {
          if (product['name'] == productName) {
            product['quantity'] = quantity;
            break;
          }
        }
      }
    });
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var product in widget.products) {
      int quantity = product['quantity'];
      double price = double.tryParse(product['price'].replaceAll('₹', '')) ?? 0;
      total += quantity * price;
    }
    return total;
  }

  Future<void> showCheckoutDialog() async {
    if (isCartEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Your cart is empty! Please add items to proceed.")),
      );
      return; // Prevent showing the checkout dialog if the cart is empty
    }

    final bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Checkout"),
          content:
              const Text("Are you sure you want to proceed with checkout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Proceed",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      clearCart();
      widget.onCartCleared?.call();
      Navigator.of(context).pop();
    }
  }

  void clearCart() async {
    setState(() {
      for (var product in widget.products) {
        product['quantity'] = 0;
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartState');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cart has been cleared. Thank you!")),
    );
  }

  void navigateToProductDetail(Map<String, dynamic> product) {
    // Navigate to ProductDetail directly
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(
          product: product,
          onQuantityChange: (int change) {
            // Update quantity from ProductDetail
            widget.onQuantityUpdate(widget.products.indexOf(product), change);
            setState(() {
              _saveCartState();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                if (product['quantity'] <= 0) return const SizedBox();
                return GestureDetector(
                  onTap: () => navigateToProductDetail(product),
                  child: ListTile(
                    leading:
                        Image.asset(product['image'], width: 50, height: 50),
                    title: Text(product['name']),
                    subtitle: Text(
                      "Qty: ${product['quantity']} | Price: ₹${product['price']} | Total: ₹${(product['quantity'] * (double.tryParse(product['price'].replaceAll('₹', '')) ?? 0)).toStringAsFixed(2)}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            widget.onQuantityUpdate(index, -1);
                            setState(() {
                              _saveCartState();
                            });
                          },
                        ),
                        Text(product['quantity'].toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            widget.onQuantityUpdate(index, 1);
                            setState(() {
                              _saveCartState();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹${calculateTotalPrice().toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isCartEmpty
                  ? null
                  : showCheckoutDialog, // Disable if cart is empty
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "Check Out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
