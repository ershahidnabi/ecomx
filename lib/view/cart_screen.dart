import 'package:flutter/material.dart';

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
  // Calculate the total cart price
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
      widget.onCartCleared?.call(); // Notify parent to clear the cart badge
      Navigator.of(context).pop(); // Return to previous screen
    }
  }

  void clearCart() {
    setState(() {
      for (var product in widget.products) {
        product['quantity'] = 0;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cart has been cleared. Thank you!")),
    );
  }

  // Navigate to Product Detail Page
  void navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
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
                            setState(() {});
                          },
                        ),
                        Text(product['quantity'].toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            widget.onQuantityUpdate(index, 1);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Display total price
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
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
              onPressed: showCheckoutDialog,
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

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(product['image'], height: 200, width: 200),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Price: ₹${product['price']}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Quantity: ${product['quantity']}",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
