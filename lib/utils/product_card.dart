// import 'package:flutter/material.dart';

// class ProductCard extends StatelessWidget {
//   final String name;
//   final String price;
//   final String imagePath;
//   final int quantity;
//   final VoidCallback onAddToCart;
//   final Function(int) onQuantityChange;

//   const ProductCard({
//     required this.name,
//     required this.price,
//     required this.imagePath,
//     required this.quantity,
//     required this.onAddToCart,
//     required this.onQuantityChange,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 4,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//             child: Image.asset(
//               imagePath,
//               height: 120,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   price,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 quantity == 0
//                     ? ElevatedButton(
//                         onPressed: onAddToCart,
//                         child: const Text('Add to Cart'),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             onPressed: () => onQuantityChange(-1),
//                             icon: const Icon(Icons.remove),
//                           ),
//                           Text(
//                             quantity.toString(),
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                           IconButton(
//                             onPressed: () => onQuantityChange(1),
//                             icon: const Icon(Icons.add),
//                           ),
//                         ],
//                       ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
