import 'package:flutter/material.dart';
import 'package:mynelayan/screens/buyertabscreen.dart';
import 'package:mynelayan/screens/newstabscreen.dart';
import 'package:mynelayan/screens/profiletabscreen.dart';
import 'package:mynelayan/screens/sellertabscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Buyer";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      const BuyerTabScreen(),
      const SellerTabScreen(),
      const ProfileTabScreen(),
      const NewsTabScreen(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(maintitle),
        ),
        body: tabchildren[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.attach_money,
                ),
                label: "Buyer"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.store_mall_directory,
                ),
                label: "Seller"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.newspaper,
                ),
                label: "News")
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Buyer";
      }
      if (_currentIndex == 1) {
        maintitle = "Seller";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
      if (_currentIndex == 3) {
        maintitle = "News";
      }
    });
  }
}
