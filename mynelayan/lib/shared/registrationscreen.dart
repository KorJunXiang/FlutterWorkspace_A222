import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mynelayan/appconfig/config.dart';
import 'package:mynelayan/shared/loginscreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _pass1EditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _isChecked = false;
  final _formkey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.35,
              width: screenWidth,
              child: Image.asset(
                'assets/images/register.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameEditingController,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 5)
                                        ? 'name must be longer than 5'
                                        : null,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Name',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.person),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2))),
                              ),
                              TextFormField(
                                controller: _phoneEditingController,
                                validator: (val) => val!.isEmpty ||
                                        (val.length < 10)
                                    ? 'phone must be longer or equal than 10'
                                    : null,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.phone),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2))),
                              ),
                              TextFormField(
                                controller: _emailEditingController,
                                validator: (val) => val!.isEmpty ||
                                        !val.contains("@") ||
                                        !val.contains(".")
                                    ? "enter a valid email"
                                    : null,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.email),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2))),
                              ),
                              TextFormField(
                                controller: _pass1EditingController,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 5)
                                        ? "password must be longer than 5"
                                        : null,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.lock),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2))),
                              ),
                              TextFormField(
                                controller: _pass2EditingController,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 5)
                                        ? "password must be longer than 5"
                                        : null,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Re-enter password',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.lock),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2))),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
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
                                          child: const Text('Register')))
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _goLogin,
              child: const Text(
                'Already Registered? Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void onRegisterDialog() {
    if (!_formkey.currentState!.validate()) {
      print('Invalid');
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please agree with the terms and conditions')));
      return;
    }
    String pass1 = _pass1EditingController.text;
    String pass2 = _pass2EditingController.text;
    if (pass1 != pass2) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Check your password')));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
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
    String phone = _phoneEditingController.text;
    String pass1 = _pass1EditingController.text;
    http.post(Uri.parse('${MyConfig.server}/php/register_user.php'), body: {
      "name": name,
      "phone": phone,
      "email": email,
      "password": pass1
    }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Registration Success',
          textAlign: TextAlign.center,
        )));
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Registration Failed',
          textAlign: TextAlign.center,
        )));
        return;
      }
    });
  }

  void _goLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
