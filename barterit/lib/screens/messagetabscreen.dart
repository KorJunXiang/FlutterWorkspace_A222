import 'package:flutter/material.dart';

class MessageTabScreen extends StatefulWidget {
  const MessageTabScreen({super.key});

  @override
  State<MessageTabScreen> createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<MessageTabScreen> {
  String maintitle = 'Message';

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
        automaticallyImplyLeading: false,
        title: Text(
          maintitle,
          style:
              const TextStyle(fontSize: 26, fontFamily: 'Merriweather.italic'),
        ),
      ),
      body: Center(child: Text(maintitle)),
    );
  }
}
