import 'package:flutter/material.dart';
import 'package:max_section11/models/grocery_item.dart';
import 'package:max_section11/widgets/new_item.dart';

import '../data/dummy_items.dart';
import '../models/category.dart';
import '../models/category.dart';
import '../models/category.dart';
import '../models/category.dart';
import '../models/category.dart';
import 'new_item.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<GroceryItem> _groceryItems =
      []; // List of grocery items to be displayed
  void _addItem() async {
    final newItem =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (ctx) => const NewItem(),
    ));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Your Groceries'),
        actions: [
          IconButton(
              onPressed: () {
                _addItem();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (
            context,
            index,
          ) =>
              ListTile(
                title: Text(_groceryItems[index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(_groceryItems[index].quantity.toString()),
              )),
    );
  }
}
