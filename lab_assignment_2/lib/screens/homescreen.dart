import 'package:flutter/material.dart';
import 'package:lab_assignment_2/models/user.dart';

class HomeTabScreen extends StatefulWidget {
  final User user;
  const HomeTabScreen({super.key, required this.user});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String maintitle = 'Home';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber.shade300,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/home.png',
              scale: 12,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              maintitle,
              style: const TextStyle(
                  fontSize: 26, fontFamily: 'Merriweather.italic'),
            )
          ],
        ),
      ),
      body: Center(
          child: Text(
        widget.user.id.toString() == 'na'
            ? 'Please login/register an account'
            : 'Welcome back, ${widget.user.name}',
        style: const TextStyle(fontFamily: 'Merriweather.italic'),
      )),
    );
  }
}
