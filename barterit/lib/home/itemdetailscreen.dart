import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lab_assignment_2/appconfig/myconfig.dart';
import 'package:lab_assignment_2/models/item.dart';
import 'package:lab_assignment_2/models/user.dart';
import 'package:http/http.dart' as http;

class ItemDetailScreen extends StatefulWidget {
  final User user;
  final Item item;

  const ItemDetailScreen(
      {super.key, required this.user, required this.item, required int page});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth, cardwitdh;

  @override
  void initState() {
    super.initState();
    qty = int.parse(widget.item.itemQty.toString());
    totalprice = double.parse(widget.item.itemPrice.toString());
    singleprice = double.parse(widget.item.itemPrice.toString());
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
          title: const Text(
        "Item Details",
        style: TextStyle(fontFamily: 'Merriweather'),
      )),
      body: Column(children: [
        Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "${MyConfig().server}/assets/items/${widget.item.itemId}_1.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "${MyConfig().server}/assets/items/${widget.item.itemId}_2.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "${MyConfig().server}/assets/items/${widget.item.itemId}_3.png",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.item.itemName.toString(),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merriweather'),
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.item.itemDesc.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Item Type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.item.itemType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Quantity",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.item.itemQty.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.item.itemPrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.item.itemLocality}/${widget.item.itemState}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      df.format(
                          DateTime.parse(widget.item.itemDate.toString())),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                onPressed: () {
                  if (userqty <= 1) {
                    userqty = 1;
                    totalprice = singleprice * userqty;
                  } else {
                    userqty = userqty - 1;
                    totalprice = singleprice * userqty;
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.remove)),
            Text(
              userqty.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () {
                  if (userqty >= qty) {
                    userqty = qty;
                    totalprice = singleprice * userqty;
                  } else {
                    userqty = userqty + 1;
                    totalprice = singleprice * userqty;
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.add)),
          ]),
        ),
        Text(
          "RM ${totalprice.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
            onPressed: () {
              addtocartdialog();
            },
            child: const Text("Add to Cart"))
      ]),
    );
  }

  void addtocartdialog() {
    if (widget.user.id.toString() == "na") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please register to add item to cart")));
      return;
    }
    if (widget.user.id.toString() == widget.item.userId.toString()) {
      Fluttertoast.showToast(
          msg: "User cannot add own item",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add to cart?",
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
                addtocart();
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

  void addtocart() {
    http.post(Uri.parse("${MyConfig().server}/php/addtocart.php"), body: {
      "item_id": widget.item.itemId.toString(),
      "item_qty": userqty.toString(),
      "item_price": totalprice.toString(),
      "userid": widget.user.id,
      "sellerid": widget.item.userId
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        Navigator.pop(context);
      }
    });
  }
}
