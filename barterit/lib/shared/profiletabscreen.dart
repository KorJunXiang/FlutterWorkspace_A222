import 'package:flutter/material.dart';
import 'package:lab_assignment_2/models/user.dart';
import 'package:lab_assignment_2/shared/loginscreen.dart';
import 'package:lab_assignment_2/shared/registrationscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;
  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  String maintitle = 'Profile';
  late double screenHeight, screenWidth;

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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            maintitle,
            style: const TextStyle(
                fontSize: 26, fontFamily: 'Merriweather.italic'),
          )),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.3,
              width: screenWidth,
              child: Card(
                color: Colors.lightBlue.shade50,
                elevation: 10,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: screenWidth * 0.35,
                    child: Image.asset(
                      'assets/images/profile.png',
                      scale: 5,
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.user.id.toString() == 'na')
                            const Text(
                              'Please login/register an account',
                              style: TextStyle(
                                fontFamily: 'Merriweather',
                              ),
                            ),
                          if (widget.user.id.toString() != 'na')
                            Column(
                              children: [
                                Text(
                                  widget.user.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 24, fontFamily: 'Merriweather'),
                                ),
                                Text(
                                  widget.user.email.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Merriweather'),
                                ),
                                Text(widget.user.datereg.toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Merriweather')),
                              ],
                            ),
                        ],
                      ))
                ]),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: screenWidth,
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.primary,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text("PROFILE SETTINGS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Merriweather.italic',
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.orange,
                      width: 3,
                    ))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const LoginScreen()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOGIN",
                          style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.login,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.orange,
                      width: 3,
                    ))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) =>
                                  const RegistrationScreen()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "REGISTRATION",
                          style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.app_registration,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.orange,
                      width: 3,
                    ))),
                    onPressed: _logout,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOGOUT",
                          style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('pass', '');
    await prefs.setBool('checkbox', false);
    setState(() {
      widget.user.id = "na";
      widget.user.name = "na";
      widget.user.email = "na";
      widget.user.datereg = "na";
      widget.user.password = "na";
      widget.user.otp = "na";
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
