// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:safaai_admin_app/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';


// class DialogBoxScreen extends StatelessWidget {
//   const DialogBoxScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return simpleDialogBox(context);
//             },
//           );
//         },
//         child: const Text("Open Dialog"),
//       ),
//     );
//   }
// }

// Widget simpleDialogBox(BuildContext context) {
//   return Dialog(
//     backgroundColor: Color(0xFF1e1f21),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Container(
//       padding: EdgeInsets.all(30),
//       width: 700,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Close Button
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.close),
//                 color: Color.fromARGB(255, 42, 254, 169),
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//               ),
//             ],
//           ),

//           // Display User Data
//           Text(
//             'Name: ${userData!['Name']}',
//             style: TextStyle(color: Colors.white),
//           ),
//           Text(
//             'Email: ${userData!['Email']}',
//             style: TextStyle(color: Colors.white),
//           ),
//           Text(
//             'SaFi Balance: ${userData!['CreditBalance']}',
//             style: TextStyle(color: Colors.white),
//           ),
//           Text(
//             'Phone Number: ${userData!['PhoneNumber']}',
//             style: TextStyle(color: Colors.white),
//           ),
//           Text(
//             'Upi Id: ${userData!['UpiId']}',
//             style: TextStyle(color: Colors.white),
//           ),
//           SizedBox(height: 40),

//           // Balance Input Field
//           Center(
//             child: Container(
//               width: 300,
//               height: 100,
//               child: TextFormField(
//                 controller: balanceController,
//                 keyboardType: TextInputType.number,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   fillColor: Color.fromARGB(255, 31, 31, 31),
//                   filled: true,
//                   hintText: "SaFi Balance",
//                   hintStyle: TextStyle(
//                     fontSize: 20.0,
//                     color: Colors.white,
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Color.fromARGB(255, 42, 254, 169),
//                       width: 0.05,
//                     ),
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),

//           // Action Buttons
//           Row(
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   updateUserBalance(
//                     selectedEmail,
//                     int.parse(balanceController.text),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor:
//                       const Color.fromARGB(255, 108, 244, 54), // Text color
//                 ),
//                 child: Text('Update SaFi Balance'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   deleteUser(selectedEmail);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.red, // Text color
//                 ),
//                 child: Text('Delete User'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
