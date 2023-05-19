import 'package:flutter/material.dart';
import 'package:mynelayan/models/user.dart';
import 'package:mynelayan/screens/newcatchscreen.dart';

class SellerTabScreen extends StatefulWidget {
  const SellerTabScreen({super.key, required this.user});
  final User user;

  @override
  State<SellerTabScreen> createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  String maintitle = 'Seller';

  @override
  void initState() {
    super.initState();
    print('Seller');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.user.id != 'na') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewCatchScreen(
                          user: widget.user,
                        )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Please login/register an account',
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 1),
            ));
          }
        },
        child: const Text(
          '+',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
