import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country App',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Country Searching App'),
            centerTitle: true,
          ),
          body: const CountryHome()),
    );
  }
}

class CountryHome extends StatefulWidget {
  const CountryHome({super.key});

  @override
  State<CountryHome> createState() => _CountryHomeState();
}

class _CountryHomeState extends State<CountryHome> {
  TextEditingController country = TextEditingController();
  var data = 'No Record Available',
      dataCodeCountry = 'No Record Available',
      dataRegionCapital = 'No Record Available',
      dataCurrency = 'No Record Available',
      code = '',
      name = '',
      region = '',
      capital = '',
      currencyName = '',
      currencyCode = '',
      flagTheme = 'flat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, bottom: 10, top: 10),
                child: TextField(
                  controller: country,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Country   (E.g. Malaysia)',
                      hintStyle: const TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _getCountry,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.yellow.shade600,
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 255, 0, 0), width: 3)),
                    child: const Text('Search', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                      onPressed: _reset,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 40),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.yellow.shade600,
                          shape: const StadiumBorder(),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 255, 0, 0), width: 3)),
                      child:
                          const Text('Reset', style: TextStyle(fontSize: 18))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 550,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.amber.shade100),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Country Information',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                        const SizedBox(height: 5),
                        if (code.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  height: 128,
                                  child: Image.network(
                                    'https://flagsapi.com/$code/$flagTheme/64.png',
                                    fit: BoxFit.cover,
                                  )),
                              Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: _flat,
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(80, 30),
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.green,
                                          shape: const StadiumBorder(),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 0, 0),
                                              width: 3)),
                                      child: const Text('flat')),
                                  ElevatedButton(
                                      onPressed: _shiny,
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(80, 30),
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.green,
                                          shape: const StadiumBorder(),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 255, 0, 0),
                                              width: 3)),
                                      child: const Text('shiny')),
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 150,
                            padding: const EdgeInsets.all(8),
                            color: Colors.cyan.shade50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_city_rounded,
                                    size: 100),
                                code.isEmpty
                                    ? Text(
                                        data,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      )
                                    : Text(
                                        dataCodeCountry,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 150,
                            padding: const EdgeInsets.all(8),
                            color: Colors.cyan.shade50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.map_outlined, size: 100),
                                code.isEmpty
                                    ? Text(
                                        data,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      )
                                    : Text(
                                        dataRegionCapital,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 150,
                            padding: const EdgeInsets.all(8),
                            color: Colors.cyan.shade50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.currency_exchange_rounded,
                                    size: 100),
                                code.isEmpty
                                    ? Text(
                                        data,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      )
                                    : Text(
                                        dataCurrency,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w800),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCountry() async {
    String countryText = country.text;
    String apiid = '5alWSBQ+rpKF44SIg2/luQ==VQmcMsmLmLBHye7o';
    Uri countryURL =
        Uri.parse('https://api.api-ninjas.com/v1/country?name=$countryText');
    var response = await http.get(countryURL, headers: {'X-Api-Key': apiid});
    if (response.statusCode == 200) {
      //request success
      String jsonData = response.body;
      var parsedJson = jsonDecode(jsonData);
      if (parsedJson.length == 0) {
        //empty json array[], length is 0
        setState(() {
          data = 'Country Not Found';
        });
      } else {
        //not empty array
        setState(() {
          code = parsedJson[0]['iso2'];
          name = parsedJson[0]['name'];
          region = parsedJson[0]['region'];
          capital = parsedJson[0]['capital'];
          currencyName = parsedJson[0]['currency']['name'];
          currencyCode = parsedJson[0]['currency']['code'];
          dataCodeCountry = 'Country Code: $code\nCountry Name: $name';
          dataRegionCapital = 'Region: $region\nCapital: $capital';
          dataCurrency =
              'Currency Code: $currencyCode\nCurrency Name: $currencyName';
        });
      }
    } else {
      setState(() {
        data = 'Country Not Found'; //request error
      });
    }
  }

  void _reset() {
    setState(() {
      country.clear(); //clear text field and information display
      data = 'No Record Available';
      code = '';
      name = '';
      region = '';
      capital = '';
      currencyName = '';
      currencyCode = '';
    });
  }

  void _flat() {
    setState(() {
      flagTheme = 'flat'; //change flag to flat
    });
  }

  void _shiny() {
    setState(() {
      flagTheme = 'shiny'; //change flag to shiny
    });
  }
}
