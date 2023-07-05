import 'package:flutter/material.dart';

class NewsTabScreen extends StatefulWidget {
  const NewsTabScreen({super.key});

  @override
  State<NewsTabScreen> createState() => _NewsTabScreenState();
}

class _NewsTabScreenState extends State<NewsTabScreen> {
  String maintitle = 'News';

  @override
  void initState() {
    super.initState();
    print('News');
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
        body: Center(child: Text(maintitle)));
  }
}
