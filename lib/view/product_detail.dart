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
    _loadProductQuantity(); // Load quantity from SharedPreferences or set default
  }

  Future<void> _loadProductQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartData = prefs.getStringList('cartState') ?? [];

    bool productFound = false;
    for (String data in cartData) {
      List<String> productData = data.split(':');
      if (productData[0] == widget.product['name']) {
        setState(() {
          quantity = int.parse(productData[1]);
        });
        productFound = true;
        break;
      }
    }

    if (!productFound) {
      setState(() {
        quantity = widget.product['quantity'] ?? 0; // Default to 0 if not found
      });
    }
  }

  Future<void> _saveProductQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartData = prefs.getStringList('cartState') ?? [];
    bool productFound = false;

    for (int i = 0; i < cartData.length; i++) {
      List<String> productData = cartData[i].split(':');
      if (productData[0] == widget.product['name']) {
        cartData[i] = '${widget.product['name']}:$quantity';
        productFound = true;
        break;
      }
    }

    if (!productFound) {
      cartData.add('${widget.product['name']}:$quantity');
    }

    await prefs.setStringList('cartState', cartData);
  }

  void updateQuantity(int change) {
    setState(() {
      quantity = (quantity + change).clamp(0, 99);
    });
    widget.onQuantityChange(change);
    _saveProductQuantity(); // Save to SharedPreferences
  }

  void addToCart() async {
    // Get the current route (screen) name
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    // Show a SnackBar with the page name
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Added to cart from $currentRoute')),
    // );

    // Save the product to SharedPreferences
    _saveProductQuantity(); // This will save the product state without altering quantity here.

    // Navigate back to the home page (or previous screen) after adding the product to the cart
    Navigator.pop(
        context); // This will pop the current screen and return to the previous screen (typically home).
  }

  // void addToCart() async {
  //   // Save the product to SharedPreferences
  //   _saveProductQuantity(); // This will save the product state without altering quantity here.

  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(content: Text('${widget.product['name']} added to cart')),
  // );

  // Navigate back to the home page (or previous screen) after adding the product to the cart
  //   Navigator.pop(
  //       context); // This will pop the current screen and return to the previous screen (typically home).
  // }

  // void addToCart() async {
  //   if (quantity == 0) {
  //     setState(() {
  //       quantity = 1;
  //     });
  //     widget.onQuantityChange(1);
  //     _saveProductQuantity(); // Save to SharedPreferences
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('${widget.product['name']} added to cart')),
  //   );

  //   // Navigate to the home page after adding the product to the cart
  //   Navigator.pop(
  //       context); // This will pop the current screen and return to the previous screen (typically home).
  // }

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
            Align(
              alignment: Alignment.centerRight, // Align to the right
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle the back navigation
                  Navigator.pop(
                      context); // This will pop the current screen and go back to the previous one
                },
                icon: const Icon(Icons.arrow_back), // Back icon
                label: const Text('Back'), // Label for the button
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Add padding for better button size
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProductDetail extends StatefulWidget {
//   final Map<String, dynamic> product;
//   final Function(int) onQuantityChange;

//   const ProductDetail({
//     required this.product,
//     required this.onQuantityChange,
//     super.key,
//   });

//   @override
//   State<ProductDetail> createState() => _ProductDetailState();
// }

// class _ProductDetailState extends State<ProductDetail> {
//   late int quantity;

//   @override
//   void initState() {
//     super.initState();
//     _loadProductQuantity(); // Load quantity from SharedPreferences
//   }

//   // Load product quantity from SharedPreferences
//   Future<void> _loadProductQuantity() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> cartData = prefs.getStringList('cartState') ?? [];
//     for (String data in cartData) {
//       List<String> productData = data.split(':');
//       if (productData[0] == widget.product['name']) {
//         setState(() {
//           quantity = int.parse(productData[1]);
//         });
//         return;
//       }
//     }
//     quantity = widget.product['quantity']; // Default if not found
//   }

//   // Save product quantity to SharedPreferences
//   Future<void> _saveProductQuantity() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> cartData = prefs.getStringList('cartState') ?? [];
//     bool productFound = false;

//     for (int i = 0; i < cartData.length; i++) {
//       List<String> productData = cartData[i].split(':');
//       if (productData[0] == widget.product['name']) {
//         cartData[i] = '${widget.product['name']}:$quantity';
//         productFound = true;
//         break;
//       }
//     }

//     if (!productFound) {
//       cartData.add('${widget.product['name']}:$quantity');
//     }

//     await prefs.setStringList('cartState', cartData);
//   }

//   void updateQuantity(int change) {
//     setState(() {
//       quantity = (quantity + change).clamp(0, 99);
//     });
//     widget.onQuantityChange(change);
//     _saveProductQuantity(); // Save to SharedPreferences
//   }

//   void addToCart() async {
//     if (quantity == 0) {
//       setState(() {
//         quantity = 1;
//       });
//       widget.onQuantityChange(1);
//       _saveProductQuantity(); // Save to SharedPreferences
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${widget.product['name']} added to cart')),
//     );

//     // Navigate to the home page after adding the product to the cart
//     Navigator.pop(
//         context); // This will pop the current screen and return to the previous screen (typically home).
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: Text(widget.product['name']),
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Image.asset(
//                 widget.product['image'],
//                 height: 250,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               widget.product['name'],
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               widget.product['price'],
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   onPressed: () => updateQuantity(-1),
//                   icon: const Icon(Icons.remove),
//                   iconSize: 32,
//                 ),
//                 Text(
//                   quantity.toString(),
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => updateQuantity(1),
//                   icon: const Icon(Icons.add),
//                   iconSize: 32,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: addToCart,
//               child: const Text('Add to Cart'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
