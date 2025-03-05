import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  final String selectedEmail;
  final Map<String, dynamic> userData;

  PaymentPage({required this.selectedEmail, required this.userData});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool showPaymentDetails = false;
  TextEditingController balanceController = TextEditingController();

 

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Details",
         style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),
        
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 42, 254, 169),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 800,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              //color:Colors.white,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Payments for ${widget.selectedEmail}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('transactions')
                      .doc(widget.selectedEmail)
                      .collection(widget.selectedEmail)
                      .orderBy('Time', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}', style: TextStyle(color: const Color.fromARGB(255, 13, 13, 13)));
                    }
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var transactionDocs = snapshot.data!.docs;
                    
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Email', style: TextStyle(color: Colors.black))),
                          DataColumn(label: Text('Redeemed Amount', style: TextStyle(color: Colors.black))),
                          DataColumn(label: Text('UPI', style: TextStyle(color: Colors.black))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.black))),
                        ],
                        rows: transactionDocs.map((DocumentSnapshot document) {
                          var data = document.data() as Map<String, dynamic>;
                          var userEmail = data['Email'] ?? '';
                          var redeemedAmount = data['RedeemAmount'] ?? 0;
                          var upiId = data['UpiId'] ?? 'N/A';

                          return DataRow(cells: [
                            DataCell(Text(userEmail, style: TextStyle(color: Colors.black))),
                            DataCell(Text(
                              '₹${(redeemedAmount / 100).toStringAsFixed(2)}',
                              style: TextStyle(color: Color.fromARGB(255, 0, 235, 141)),
                            )),
                            DataCell(Text(upiId, style: TextStyle(color: Colors.black))),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.content_copy),
                                color: Color.fromARGB(255, 0, 235, 141),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: upiId));
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Copied"),
                                      content: Text("UPI ID copied to clipboard"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to home page
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:Color.fromARGB(255, 42, 254, 169),
                    ),
                    child: Text("Back to Home",
                     style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
