import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BuyerTabScreen extends StatefulWidget {
  const BuyerTabScreen({super.key});

  @override
  State<BuyerTabScreen> createState() => _BuyerTabScreenState();
}

class _BuyerTabScreenState extends State<BuyerTabScreen> {
  String maintitle = 'Buyer';

  @override
  void initState() {
    super.initState();
    print('Buyer');
  }
  
  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(maintitle));
  }
}
