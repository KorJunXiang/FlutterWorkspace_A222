import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab_assignment_2/models/user.dart';
import 'package:lab_assignment_2/myconfig.dart';
import 'package:lab_assignment_2/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
    // Timer(
    //     const Duration(seconds: 3),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (content) => const MainScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 214, 209, 214),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splashscreen.png'),
                        scale: 2,
                        alignment: Alignment.center))),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "BARTER IT",
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Merriweather.italic',
                        color: Colors.black),
                  ),
                  CircularProgressIndicator(),
                  Text(
                    "Version 0.1",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Merriweather',
                        color: Colors.black),
                  )
                ],
              ),
            )
          ],
        ));
  }

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        print('yes');
        http.post(Uri.parse("${MyConfig.server}/php/user_login.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            print(jsondata);
            user = User.fromJson(jsondata['data']);
            // user = User(
            //     id: "na",
            //     name: "na",
            //     email: "na",
            //     datereg: "na",
            //     password: "na",
            //     otp: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                datereg: "na",
                password: "na",
                otp: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {});
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      print('no');
      user = User(
          id: "na",
          name: "na",
          email: "na",
          datereg: "na",
          password: "na",
          otp: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
