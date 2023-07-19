import 'dart:convert';
// import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lab_assignment_2/appconfig/myconfig.dart';
import 'package:lab_assignment_2/item/sellerorderscreen.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:lab_assignment_2/models/item.dart';
import 'package:lab_assignment_2/models/user.dart';
import 'package:lab_assignment_2/item/edititemscreen.dart';
import 'package:lab_assignment_2/item/newitemscreen.dart';
import 'package:http/http.dart' as http;

class ItemTabScreen extends StatefulWidget {
  final User user;
  const ItemTabScreen({super.key, required this.user});

  @override
  State<ItemTabScreen> createState() => _ItemTabScreenState();
}

class _ItemTabScreenState extends State<ItemTabScreen> {
  String maintitle = 'Item';
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  List<Item> itemList = <Item>[];

  @override
  void initState() {
    super.initState();
    loadsellerItems();
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
            style: const TextStyle(
                fontSize: 26, fontFamily: 'Merriweather.italic'),
          ),
          actions: [
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("My Order"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("New"),
                ),
              ];
            }, onSelected: (value) async {
              if (value == 0) {
                if (widget.user.id.toString() == "na") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please login/register an account")));
                  return;
                }
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => SellerOrderScreen(
                              user: widget.user,
                            )));
              } else if (value == 1) {
              } else if (value == 2) {}
            }),
            // IconButton(
            //     onPressed: () {
            //       _clearImageCache();
            //     },
            //     icon: const Icon(Icons.refresh))
          ]),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: widget.user.id.toString() == 'na'
            ? const Center(
                child: Text('Please login/register an account',
                    style: TextStyle(fontFamily: 'Merriweather.italic')),
              )
            : itemList.isEmpty
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
                          "${itemList.length} Items Found",
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
                                    onLongPress: () {
                                      onDeleteDialog(index);
                                    },
                                    onTap: () async {
                                      Item singleItem = Item.fromJson(
                                          itemList[index].toJson());
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditItemScreen(
                                                    user: widget.user,
                                                    item: singleItem),
                                          ));
                                      loadsellerItems();
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Text(
                                            itemList[index].itemName.toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily:
                                                    "Merriweather.italic"),
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
                  ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewItemScreen(user: widget.user)));
              loadsellerItems();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  void loadsellerItems() {
    if (widget.user.id == "na") {
      setState(() {
        const Text(
          'Please login/register an account',
          style: TextStyle(fontFamily: 'Merriweather.italic'),
        );
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().server}/php/load_items.php"),
        body: {"userid": widget.user.id}).then((response) {
      // print(response.body);
      // log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
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

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().server}/php/delete_item.php"), body: {
      "userid": widget.user.id,
      "itemid": itemList[index].itemId
    }).then((response) {
      print(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadsellerItems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  Future<void> _refresh() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        itemList.clear();
        loadsellerItems();
        setState(() {});
      },
    );
  }

  // Future<void> _clearImageCache() async {
  //   await DefaultCacheManager().emptyCache();
  //   // ignore: use_build_context_synchronously
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Image cache cleared.'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }
}
