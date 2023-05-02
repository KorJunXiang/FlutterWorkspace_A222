import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var temp = 0.0, hum = 0, desc = "No records", weather = "";
  String selectLoc = "Changlun";
  List<String> locList = [
    "Changlun",
    "Jitra",
    "Ipoh",
    "Kuala Lumpur",
    "Alor Setar",
    "Cameron",
    "Selayang",
    "ABC",
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Simple Weather",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          DropdownButton(
            itemHeight: 60,
            value: selectLoc,
            onChanged: (newValue) {
              setState(() {
                selectLoc = newValue.toString();
              });
            },
            items: locList.map((selectLoc) {
              return DropdownMenuItem(
                value: selectLoc,
                child: Text(
                  selectLoc,
                ),
              );
            }).toList(),
          ),
          ElevatedButton(
              onPressed: _getWeather, child: const Text("Load Weather")),
          Text(desc,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _getWeather() async {
    String apiid = "3af620bf764b348f974b53d56093077a";
    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$selectLoc&appid=$apiid&units=metric');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        temp = parsedJson['main']['temp'];
        hum = parsedJson['main']['humidity'];
        weather = parsedJson['weather'][0]['main'];
        desc =
            "The current weather in $selectLoc is $weather.\nThe current temperature is $temp Celcius and humidity is $hum percent. ";
      });
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }
}
