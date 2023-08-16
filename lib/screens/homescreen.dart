import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:max_section11/block/endpoints.dart';
import 'package:max_section11/models/grocery_item.dart';
import 'package:http/http.dart' as http;

import '../data/categories.dart';
import 'add_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  final List<GroceryItem> _groceryItems = [];
  var isLoading = false;
  var isSending = false;
  var error;

  void _loadItems() async {
    try {
      final Url = Uri.https(databaseUrl, 'shopping - list.json');
      final response = await http.get(Url);

      if (response.statusCode >= 400) {
        setState(() {
          error = "failed to load items";
        });
      }

      print(response.statusCode);
      final Map<String, dynamic> listData = jsonDecode(response.body);
      final List<GroceryItem> _loadedItems = [];
      print(response.body);
      for (var item in listData.entries) {
        final catregory = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        _loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value["quantity"],
            category: catregory,
          ),
        );
      }
      setState(() {
        _groceryItems.addAll(_loadedItems);
        isLoading = false;
      });
    } catch (e, s) {
      setState(() {
        isLoading = false;
      });
      print("error:$e");
      print("error:$s");
    }
  }

  // List of grocery items to be displayed
  void _addItem() async {
    final newItem =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (ctx) => const NewItem(),
    ));
    // _loadItems();
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    try {
      final url = Uri.https(databaseUrl, 'shopping - list/${item.id}.json');
      await http.delete(url);
    } catch (e) {
      print("Error in removeItem $e");
    }

    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('Loading....'));
    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else {
      content = Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(
              onPressed: () {
                _addItem();
              },
              icon: const Icon(Icons.add),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _groceryItems.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    _groceryItems[index].name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  leading: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _groceryItems[index].category.color,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _groceryItems[index].quantity.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            _removeItem(_groceryItems[index]);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              ),
      );
    }

    return content;
  }
}
