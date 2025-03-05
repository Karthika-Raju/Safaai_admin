import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBinPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final CollectionReference binsCollection =
      FirebaseFirestore.instance.collection('bin'); // Firestore collection

  void showCenteredSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 2.5, // Centered
          left: 50,
          right: 50,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BIN MANAGEMENT",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 42, 254, 169),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Input
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 80, 79, 79),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Location Input
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 80, 79, 79),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 25),

              // Buttons (Add & Delete) in the same row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Add Bin Button
                  ElevatedButton(
                    onPressed: () async {
                      String title = titleController.text.trim();
                      String location = locationController.text.trim();

                      if (title.isNotEmpty && location.isNotEmpty) {
                        try {
                          // Check if a bin with the same title and location already exists
                          QuerySnapshot querySnapshot = await binsCollection
                              .where('title', isEqualTo: title)
                              .where('location', isEqualTo: location)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            showCenteredSnackBar(
                                context, "Bin already exists!", Colors.orange);
                          } else {
                            await binsCollection.add({
                              'title': title,
                              'location': location,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                           showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Success"),
                                content: Text("Bin added successfully!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );

                            // Clear input fields
                            titleController.clear();
                            locationController.clear();
                          }
                        } catch (e) {
                          showCenteredSnackBar(
                              context, "Error: $e", Colors.red);
                        }
                      } else {
                        showCenteredSnackBar(
                            context, "Please enter all details", Colors.orange);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),

                  // Delete Bin Button
                  ElevatedButton(
                    onPressed: () async {
                      String title = titleController.text.trim();
                      String location = locationController.text.trim();

                      if (title.isNotEmpty && location.isNotEmpty) {
                        try {
                          QuerySnapshot querySnapshot = await binsCollection
                              .where('title', isEqualTo: title)
                              .where('location', isEqualTo: location)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            for (QueryDocumentSnapshot doc in querySnapshot.docs) {
                              await binsCollection.doc(doc.id).delete();
                            }

                            showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Success"),
                                content: Text("Bin deleted successfully!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );


                            // Clear input fields
                            titleController.clear();
                            locationController.clear();
                          } else {
                            showCenteredSnackBar(
                                context, "Bin not found", Colors.red);
                          }
                        } catch (e) {
                          showCenteredSnackBar(
                              context, "Error: $e", Colors.red);
                        }
                      } else {
                        showCenteredSnackBar(
                            context, "Enter bin title and location to delete", Colors.orange);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
