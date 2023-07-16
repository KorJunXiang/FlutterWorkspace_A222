import 'package:flutter/material.dart';
import 'package:lab_assignment_2/models/user.dart';
import 'package:lab_assignment_2/home/homescreen.dart';
import 'package:lab_assignment_2/item/itemtabscreen.dart';
import 'package:lab_assignment_2/shared/messagetabscreen.dart';
import 'package:lab_assignment_2/shared/profiletabscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = 'Home';

  @override
  void initState() {
    super.initState();
    tabchildren = [
      HomeTabScreen(user: widget.user),
      ItemTabScreen(user: widget.user),
      const MessageTabScreen(),
      ProfileTabScreen(user: widget.user)
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.change_circle,
                ),
                label: "Item"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: "Message"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Item";
      }
      if (_currentIndex == 2) {
        maintitle = "Message";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
