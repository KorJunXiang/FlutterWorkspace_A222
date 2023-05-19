import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab_assignment_2/myconfig.dart';
import 'package:lab_assignment_2/screens/loginscreen.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _pass1EditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  late double screenHeight, screenWidth;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _passwordVisible = true;
  bool _password2Visible = true;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Registration',
          style: TextStyle(fontFamily: 'Merriweather'),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
              height: screenHeight * 0.35,
              width: screenWidth,
              child: Image.asset(
                "assets/images/register.png",
                fit: BoxFit.contain,
              )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              child: Container(
                margin: const EdgeInsets.all(12),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          controller: _nameEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "name must be longer than 5"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                fontFamily: 'Merriweather.italic',
                              ),
                              icon: Icon(Icons.person_pin_rounded),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _emailEditingController,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "enter a valid email"
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontFamily: 'Merriweather.italic',
                              ),
                              icon: Icon(Icons.email_rounded),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _pass1EditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          keyboardType: TextInputType.text,
                          obscureText: _passwordVisible,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                fontFamily: 'Merriweather.italic',
                              ),
                              icon: const Icon(Icons.lock_person_rounded),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  )),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _pass2EditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          keyboardType: TextInputType.text,
                          obscureText: _password2Visible,
                          decoration: InputDecoration(
                              labelText: 'Re-enter password',
                              labelStyle: const TextStyle(
                                fontFamily: 'Merriweather.italic',
                              ),
                              icon: const Icon(Icons.lock_person_rounded),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _password2Visible = !_password2Visible;
                                    });
                                  },
                                  icon: Icon(
                                    _password2Visible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  )),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              if (!_isChecked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Terms have been read and accepted.')));
                              }
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: null,
                            child: const Text('Agree with terms',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: onRegisterDialog,
                                  child: const Text("Register",
                                      style: TextStyle(
                                        fontFamily: 'Merriweather',
                                      ))))
                        ],
                      )
                    ]),
                  )
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: _goLogin,
            child: const Text(
              "Already Registered? Login",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Merriweather',
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ]),
      ),
    );
  }

  void _goLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Check your input'), duration: Duration(seconds: 2)));
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please agree with terms and conditions'),
          duration: Duration(seconds: 2)));
      return;
    }
    String passa = _pass1EditingController.text;
    String passb = _pass2EditingController.text;
    if (passa != passb) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Check your password'),
          duration: Duration(seconds: 2)));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: const Text(
            "Register new account?",
            style: TextStyle(
              fontFamily: 'Merriweather',
            ),
          ),
          content: const Text("Are you sure?",
              style: TextStyle(
                fontFamily: 'Merriweather',
              )),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void registerUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String password = _pass1EditingController.text;

    http.post(Uri.parse('${MyConfig.server}/php/user_register.php'), body: {
      "name": name,
      "email": email,
      "password": password,
    }).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Fluttertoast.showToast(
              msg: 'Registration Success', toastLength: Toast.LENGTH_SHORT);
        } else {
          Fluttertoast.showToast(
              msg: 'Registration Failed', toastLength: Toast.LENGTH_SHORT);
        }
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: 'Registration Failed', toastLength: Toast.LENGTH_SHORT);
        Navigator.pop(context);
      }
    });
  }
}
