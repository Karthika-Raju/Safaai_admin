import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safaai_admin_app/addbin.dart';
import 'package:safaai_admin_app/bottomnav.dart';
import 'package:safaai_admin_app/home.dart';
import 'package:safaai_admin_app/map.dart';
import 'package:safaai_admin_app/splashscreen.dart';

/// Background notification handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background notification received: ${message.notification?.title}");
}

/// Local Notifications Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Setup Local Notifications
void setupLocalNotifications() {
  const AndroidInitializationSettings androidInitialize =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitialize);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

/// Send Local Notification
void sendNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id', 'channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title,
    body,
    notificationDetails,
  );
}

/// Listen to Firestore for Bin Full Notifications
void listenToFirestore() {
  FirebaseFirestore.instance.collection('bin').snapshots().listen((snapshot) {
    for (var doc in snapshot.docs) {
      int wasteLevel = doc['description'];
      if (wasteLevel == 100) {
        sendNotification("Bin Full Alert 🚨", "Bin ${doc.id} is full!");
      }
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocalNotifications(); // Initialize Local Notifications
  listenToFirestore(); // Start Firestore listener for bin updates

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomePage(),
        '/ho': (context) => Home(),
        '/bottomnav': (context) => BottomNav(),
        '/addbin': (context) => AddBinPage(),
      },
    );
  }
}
