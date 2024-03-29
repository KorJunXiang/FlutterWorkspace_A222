import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mynelayan/models/user.dart';
import 'package:mynelayan/shared/mainscreen.dart';
import 'package:mynelayan/shared/registrationscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mynelayan/appconfig/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              height: screenHeight * 0.40,
              width: screenWidth,
              child: Image.asset(
                "assets/images/login.png",
                fit: BoxFit.cover,
              )),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(children: [
                  Form(
                    key: _formkey,
                    child: Column(children: [
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
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _passEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? value) {
                              saveremovepref(value!);
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: null,
                              child: const Text('Remember Me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: screenWidth / 3,
                            height: 50,
                            elevation: 10,
                            onPressed: _loginuser,
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onError,
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
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
            onTap: _goToRegister,
            child: const Text(
              "New account?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: _forgotDialog,
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _loginuser() {
    if (!_formkey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Check your input',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1)));
      _isChecked = false;
      return;
    }
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    http.post(Uri.parse("${MyConfig.server}/php/login_user.php"),
        body: {"email": email, "password": password}).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);  
        if (jsondata['status'] == 'success') {
          User user = User.fromJson(jsondata['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Login Success",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
          ));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(
                        user: user,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            "Login Failed",
            textAlign: TextAlign.center,
          )));
        }
      }
    });
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formkey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Please fill in the login credentials',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1)));
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool('checkbox', value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Preferences Stored',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1)));
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Preferences Removed', textAlign: TextAlign.center),
          duration: Duration(seconds: 1)));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        _isChecked = true;
      });
    }
  }

  void _goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _forgotDialog() {}
}
