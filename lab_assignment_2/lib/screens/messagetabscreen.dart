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
        foregroundColor: Colors.black,
        backgroundColor: Colors.orange.shade300,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/chat.png',
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
