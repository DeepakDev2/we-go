// import 'package:flutter/material.dart';
// import 'package:we_go/models/post_model.dart';

// class PostCard extends StatelessWidget {
//   const PostCard({super.key, required this.post});
//   final PostModel post;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 300,
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       decoration: BoxDecoration(
//         // color: Colors.green,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Text(
//               post.senderName,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.greenAccent,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Image.network(
//               post.image,
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//           ),

//           const SizedBox(height: 8),
//           Row(
//             children: [
//               IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.favorite, color: Colors.red),
//               ),
//               IconButton(onPressed: () {}, icon: Icon(Icons.chat)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Text(post.desctiption),
//           ),
//         ],
//       ),
//     );
//   }
// }
