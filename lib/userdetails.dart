import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userData;

  UserDetailsPage({required this.email, required this.userData});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late TextEditingController balanceController;

  @override
  void initState() {
    super.initState();
    balanceController = TextEditingController(
        text: widget.userData['CreditBalance'].toString());
  }

  Future<void> updateUserBalance(String email, int newBalance) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(email).update({
        'CreditBalance': newBalance,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SaFi balance updated successfully')),
      );
      setState(() {
        widget.userData['CreditBalance'] = newBalance;
      });
    } catch (error) {
      print('Error updating credit balance: $error');
    }
  }

  Future<void> deleteUser(String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(email).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
      Navigator.pop(context);
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details",style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),
        
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 42, 254, 169)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${widget.userData['Name']}", style: TextStyle(fontSize: 18)),
            Text("Email: ${widget.email}", style: TextStyle(fontSize: 18)),
            Text("Phone: ${widget.userData['PhoneNumber']}", style: TextStyle(fontSize: 18)),
            Text("UPI ID: ${widget.userData['UPIID']}", style: TextStyle(fontSize: 18)),
            Text("SaFi Balance: ${widget.userData['CreditBalance']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            
            SizedBox(height: 20),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter new SaFi balance",
                border: OutlineInputBorder()
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    
                    int newBalance = int.tryParse(balanceController.text) ?? 0;
                    updateUserBalance(widget.email, newBalance);
                  },
                   style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 42, 254, 169)),
                  child: Text("Update SaFi Balance",style: TextStyle(
            
            fontWeight: FontWeight.bold,color:Colors.black
          ),),
                ),
                ElevatedButton(
                  onPressed: () => deleteUser(widget.email),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Delete User",style: TextStyle(
            
            fontWeight: FontWeight.bold,color: Colors.black
          ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
