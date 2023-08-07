import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:max_section11/models/grocery_item.dart';
import 'package:max_section11/widgets/new_item.dart';
import 'package:http/http.dart' as http;

import '../data/categories.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  final List<GroceryItem> _groceryItems = [];
  var isLoading = true;
  var isSending = false;

  void _loadItems() async {
    final Url = Uri.https('abc.flutter-prep-9b1cf-default-rtdb.firebaseio.com',
        'shopping - list.json');
    final response = await http.get(Url);
    if (response.statusCode >= 400) print(response.statusCode);
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

  // void _removeItem(GroceryItem item) {
  //   setState(() {
  //     _groceryItems.remove(item);
  //   });
  // }
  void _removeItem(int index) {
    setState(() {
      _groceryItems.removeAt(index);
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
            IconButton(
              onPressed: () {
                _removeItem(0);
              },
              icon: const Icon(Icons.remove),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    return content;
  }
}
