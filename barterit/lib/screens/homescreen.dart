import 'dart:convert';
// import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lab_assignment_2/models/item.dart';
import 'package:lab_assignment_2/models/user.dart';
import 'package:lab_assignment_2/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:lab_assignment_2/screens/itemdetailscreen.dart';

class HomeTabScreen extends StatefulWidget {
  final User user;
  const HomeTabScreen({super.key, required this.user});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String maintitle = 'Home';
  late double screenHeight, screenWidth;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  late int axiscount = 2;
  // ignore: prefer_typing_uninitialized_variables
  var color;
  List<Item> itemList = <Item>[];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItems(1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          maintitle,
          style:
              const TextStyle(fontSize: 26, fontFamily: 'Merriweather.italic'),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search)),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
              label: const Text('0'))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: itemList.isEmpty
            ? const Center(
                child: Text("No Data",
                    style: TextStyle(fontFamily: 'Merriweather.italic')),
              )
            : Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Container(
                    height: 30,
                    color: Theme.of(context).colorScheme.primary,
                    alignment: Alignment.center,
                    child: Text(
                      "$numberofresult Items Found",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: axiscount,
                        childAspectRatio: 0.9,
                        children: List.generate(
                          itemList.length,
                          (index) {
                            return Card(
                              color: Colors.cyan.shade50,
                              elevation: 5,
                              child: InkWell(
                                onTap: () async {
                                  Item item =
                                      Item.fromJson(itemList[index].toJson());
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemDetailScreen(
                                            user: widget.user, item: item),
                                      ));
                                  // loadItems(1);
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          width: screenWidth,
                                          imageUrl:
                                              "${MyConfig().server}/assets/items/${itemList[index].itemId}_1.png",
                                          placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Text(
                                        itemList[index].itemName.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Merriweather.italic"),
                                      ),
                                      Text(
                                        "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Merriweather"),
                                      ),
                                      Text(
                                        "Quantity: ${itemList[index].itemQty}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Merriweather"),
                                      ),
                                    ]),
                              ),
                            );
                          },
                        ))),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((curpage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadItems(index + 1);
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ));
                    },
                  ),
                ),
              ]),
      ),
    );
  }

  void loadItems(int page) {
    http.post(Uri.parse("${MyConfig().server}/php/load_items.php"),
        body: {"pageno": page.toString()}).then((response) {
      // print(response.body);
      // log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  Future<void> _refresh() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          itemList.clear();
          curpage = 1;
          loadItems(1);
        });
      },
    );
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search?",
            style: TextStyle(),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchItem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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

  void searchItem(String search) {
    http.post(Uri.parse("${MyConfig().server}/php/load_items.php"),
        body: {"search": search}).then((response) {
      //print(response.body);
      // log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
            numberofresult = itemList.length;
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }
}
