import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:safaai_admin_app/main.dart';
import 'package:safaai_admin_app/paymentpage.dart';
import 'package:safaai_admin_app/userdetails.dart';

// import 'package:safaai_admin_app/dialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userData;
  TextEditingController balanceController = TextEditingController();
  String selectedEmail = '';
  bool showPaymentDetails = false;

  // Future<void> getUserDetails(String email) async {
  //   try {
  //     DocumentSnapshot docSnapshot =
  //         await FirebaseFirestore.instance.collection('users').doc(email).get();

  //     if (docSnapshot.exists) {
  //       setState(() {
  //         userData = docSnapshot.data() as Map<String, dynamic>?;
  //         balanceController.text = userData!['CreditBalance'].toString();
  //         selectedEmail = email;
  //         showPaymentDetails = false; // Hide payment details if any
  //       });
  //       print('User Details: $userData');
  //     } else {
  //       print('No user found with the provided email');
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('User Not Found'),
  //             content: Text('No user found with the provided email.'),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       setState(() {
  //         userData = null;
  //         selectedEmail = '';
  //       });
  //     }
  //   } catch (error) {
  //     print('Error retrieving user details: $error');
  //     setState(() {
  //       userData = null;
  //       selectedEmail = '';
  //     });
  //   }
  // }

  // Future<void> updateUserBalance(String email, int newBalance) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('users').doc(email).update({
  //       'CreditBalance': newBalance,
  //     });
  //     print('Credit balance updated successfully');
  //     getUserDetails(email);
  //     // Show a dialog box indicating successful balance update
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Balance Updated'),
  //           content:
  //               Text('SaFi balance for $email has been updated successfully.'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } catch (error) {
  //     print('Error updating credit balance: $error');
  //   }
  // }

  // Future<void> deleteUser(String email) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('users').doc(email).delete();
  //     print('User deleted successfully');
  //     setState(() {
  //       userData = null;
  //       selectedEmail = '';
  //     });
  //     // Show a dialog box indicating successful deletion
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('User Deleted'),
  //           content:
  //               Text('User with email $email has been deleted successfully.'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } catch (error) {
  //     print('Error deleting user: $error');
  //   }
  // }
  void showFullBinsDialog(BuildContext context, QuerySnapshot snapshot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Full Bins 🚨"),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: snapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text("Bin ID: ${doc.id}"),
                subtitle: Text("Location: ${data['location'] ?? 'Unknown'}"),
                trailing: Text("Waste Level: ${data['description']}%"),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 42, 254, 169),
        //toolbarHeight: 100,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 42, 254, 169),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.menu, size: 30, color: Colors.white),
            onPressed: () {
              // TODO: Implement Drawer action
            },
          ),
          title: Center(
            child: Text(
              "SaFaai Admin",
              textAlign: TextAlign.center, // Changed 'justify' to 'center'
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                fontFamily: 'Gilroy',
                color: Color.fromARGB(255, 41, 40, 40),
              ),
            ),
          ),
          actions: [
            // StreamBuilder to listen for real-time updates on full bins
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bin')
                  .where('description', isEqualTo: 100) // Get only full bins
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return IconButton(
                    icon: Icon(Icons.notifications,
                        size: 30, color: Colors.white),
                    onPressed: () {}, // No action when data is not available
                  );
                }

                int fullBinCount = snapshot.data!.docs.length;

              return IconButton(
  icon: Stack(
    children: [
      Icon(Icons.notifications, size: 30, color: Colors.white),
      if (fullBinCount > 0)
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Text(
              fullBinCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  ),
  onPressed: () {
    if (fullBinCount > 0) {
      showFullBinsDialog(context, snapshot.data!);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("No Full Bins"),
          content: Text("Currently, no bins are full."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  },
);
}

        ),]),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      var userDocs = snapshot.data!.docs;

                      return SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Enable horizontal scrolling
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('View Details')),
                            DataColumn(label: Text('Pending Payments')),
                          ],
                          rows: userDocs.map((DocumentSnapshot document) {
                            var data = document.data() as Map<String, dynamic>;
                            var email = data['Email'];

                            return DataRow(
                              cells: [
                                DataCell(Text(email)),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserDetailsPage(
                                            email: email,
                                            userData: data,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.payment),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentPage(
                                            selectedEmail:
                                                email, // Pass the selected user email
                                            userData: data, // Pass user data
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),);
  }
}
