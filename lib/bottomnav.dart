import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:safaai_admin_app/addbin.dart';
import 'package:safaai_admin_app/home.dart';
//import 'package:safaai_admin_app/homescreen.txt';
import 'package:safaai_admin_app/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safaai Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomNav(), // Directly set BottomNav as the home screen
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomePage homePage;
  late Home redeemPage;
  late Placeholder transactionHistoryScreen;

  @override
  void initState() {
    super.initState();
    pages = [
      // Map Page
      Home(),
      HomePage(), // Home Page
      AddBinPage(), // Replace with your History Page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Render the current page as the background
        Positioned.fill(
          child: pages[currentTabIndex],
        ),

        // Place the navigation bar on top of the pages
        Align(
          alignment: Alignment.bottomCenter,
          child: CurvedNavigationBar(
            height: 75,
            backgroundColor: Colors.transparent,
            color: const Color.fromARGB(255, 42, 254, 169),
            animationDuration: const Duration(milliseconds: 500),
            index: currentTabIndex,
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            items: [
              Icon(
                Icons.remove_red_eye,
                color: currentTabIndex == 0
                    ? Colors.white // Active color
                    : const Color.fromARGB(255, 23, 23, 23),
              ),
              Icon(
                Icons.my_location,
                color: currentTabIndex == 1
                    ? Colors.white // Active color
                    : const Color.fromARGB(255, 23, 23, 23),
              ),
              Icon(
                Icons.delete,
                color: currentTabIndex == 2
                    ? Colors.white // Active color
                    : const Color.fromARGB(255, 23, 23, 23),
              ),
            ],
          ),
        )
      ],
    );
  }
}
