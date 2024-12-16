import 'package:ecomx/model/product_list.dart';
import 'package:ecomx/utils/product_card.dart';
import 'package:ecomx/view/cart_screen.dart';
import 'package:ecomx/view/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // product list

  @override
  void initState() {
    super.initState();
    _loadCartState(); // Load saved cart state
  }

  // Save the cart state to SharedPreferences
  Future<void> _saveCartState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartData = products
        .map((product) => '${product['name']}:${product['quantity']}')
        .toList();
    await prefs.setStringList('cartState', cartData);
  }

  // Load the cart state from SharedPreferences
  Future<void> _loadCartState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartData = prefs.getStringList('cartState') ?? [];
    setState(() {
      for (String data in cartData) {
        List<String> productData = data.split(':');
        String productName = productData[0];
        int quantity = int.parse(productData[1]);

        // Update the quantity in the product list
        for (var product in products) {
          if (product['name'] == productName) {
            product['quantity'] = quantity;
            break;
          }
        }
      }
    });
  }

  void addToCart(int index) {
    setState(() {
      products[index]['quantity'] = 1;
    });
    _saveCartState();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${products[index]['name']} added to cart')),
    );
  }

  void updateQuantity(int index, int change) {
    setState(() {
      products[index]['quantity'] =
          (products[index]['quantity'] + change).clamp(0, 99);
    });
    _saveCartState();
  }

  void clearCart() async {
    setState(() {
      for (var product in products) {
        product['quantity'] = 0;
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartState');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cart cleared')),
    );
  }

  int getTotalCartItems() {
    return products.fold<int>(
        0, (sum, product) => sum + product['quantity'] as int);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('ECOM-X'),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        products: products,
                        onQuantityUpdate: (index, change) {
                          setState(() {
                            products[index]['quantity'] =
                                (products[index]['quantity'] + change)
                                    .clamp(0, 99);
                          });
                        },
                        onCartCleared: clearCart,
                      ),
                    ),
                  );
                  setState(() {}); // Refresh UI to update the cart badge
                },
                icon: const Icon(Icons.shopping_cart),
              ),
              Positioned(
                right: 5,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minHeight: 16,
                    minWidth: 16,
                  ),
                  child: Center(
                    child: Text(
                      getTotalCartItems().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('User Name'),
              accountEmail: Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.account_circle, size: 50),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetail(
                      product: products[index],
                      onQuantityChange: (change) {
                        setState(() {
                          products[index]['quantity'] =
                              (products[index]['quantity'] + change)
                                  .clamp(0, 99);
                        });
                      },
                    ),
                  ),
                );
              },
              child: ProductCard(
                name: products[index]['name'],
                price: products[index]['price'],
                imagePath: products[index]['image'],
                quantity: products[index]['quantity'],
                onAddToCart: () => addToCart(index),
                onQuantityChange: (change) => updateQuantity(index, change),
              ),
            );
          },
        ),
      ),
    );
  }
}
