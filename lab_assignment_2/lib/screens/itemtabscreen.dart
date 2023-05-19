import 'package:flutter/material.dart';

class ItemTabScreen extends StatefulWidget {
  const ItemTabScreen({super.key});

  @override
  State<ItemTabScreen> createState() => _ItemTabScreenState();
}

class _ItemTabScreenState extends State<ItemTabScreen> {
  String maintitle = 'Item';

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
        backgroundColor: Colors.blue.shade300,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/product.png',
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
      body: Center(child: Text(maintitle)),
    );
  }
}
