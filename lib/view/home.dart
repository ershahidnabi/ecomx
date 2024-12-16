// import 'package:ecomx/model/product_list.dart';
// import 'package:ecomx/utils/product_card.dart';
// import 'package:ecomx/view/cart_screen.dart';
// import 'package:ecomx/view/product_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
// // listt of products

//   // Method to calculate the total number of items in the cart
//   int getTotalCartItems() {
//     return products.fold<int>(
//         0, (sum, product) => sum + product['quantity'] as int);
//   }

//   void addToCart(int index) async {
//     setState(() {
//       products[index]['quantity'] = 1; // Set initial quantity to 1.
//     });
//     final prefs = await SharedPreferences.getInstance();
//     List<String> cart = prefs.getStringList('cart') ?? [];
//     cart.add(products[index]['name']);
//     await prefs.setStringList('cart', cart);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${products[index]['name']} added to cart')),
//     );
//   }

//   void updateQuantity(int index, int change) {
//     setState(() {
//       products[index]['quantity'] = (products[index]['quantity'] + change)
//           .clamp(0, 99); // Update quantity.
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 5,
//         title: Text("ECOM-X"),
//         actions: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               IconButton(
//                 onPressed: () async {
//                   // Navigate to CartScreen and wait for cart updates
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CartScreen(
//                         products: products,
//                         onQuantityUpdate: (index, change) {
//                           setState(() {
//                             products[index]['quantity'] =
//                                 (products[index]['quantity'] + change)
//                                     .clamp(0, 99);
//                           });
//                         },
//                         onCartCleared: () {
//                           setState(() {
//                             // Reset all product quantities when cart is cleared
//                             for (var product in products) {
//                               product['quantity'] = 0;
//                             }
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                   setState(() {}); // Refresh UI to update the cart badge
//                 },
//                 icon: const Icon(Icons.shopping_cart),
//                 // iconSize: 28,
//               ),
//               Positioned(
//                 right: 5,
//                 top: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(4.0),
//                   decoration: const BoxDecoration(
//                     color: Colors.redAccent,
//                     shape: BoxShape.circle,
//                   ),
//                   constraints: const BoxConstraints(
//                     minHeight: 16,
//                     minWidth: 16,
//                   ),
//                   child: Center(
//                     child: Text(
//                       getTotalCartItems().toString(), // Updates dynamically
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: Text('User Name'),
//               accountEmail: Text('user@example.com'),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.orange,
//                 child: Icon(Icons.account_circle, size: 50),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//               onTap: () {
//                 // Handle profile tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 // Handle settings tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.info),
//               title: Text('About'),
//               onTap: () {
//                 // Handle about tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text('Logout'),
//               onTap: () {
//                 // Handle logout tap
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(8.0),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10.0,
//                   mainAxisSpacing: 10.0,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       // Navigate to ProductDetail screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductDetail(
//                             product: products[index], // Passing product data
//                             onQuantityChange: (change) {
//                               setState(() {
//                                 products[index]['quantity'] =
//                                     (products[index]['quantity'] + change)
//                                         .clamp(0, 99);
//                               });
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                     child: ProductCard(
//                       name: products[index]['name'],
//                       price: products[index]['price'],
//                       imagePath: products[index]['image'],
//                       quantity: products[index]['quantity'],
//                       onAddToCart: () => addToCart(index),
//                       onQuantityChange: (change) =>
//                           updateQuantity(index, change),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
