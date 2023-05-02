import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SellerTabScreen extends StatefulWidget {
  const SellerTabScreen({super.key});

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
    return Center(
      child: Text(maintitle));
  }
}
