import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:max_section11/models/grocery_item.dart';
import '../data/categories.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // Variable to hold the selected category
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var isSending = false;

  var _enteredQuantity = 1;
  var selectedCategory = categories[Categories.vegetables]!;
  void _SaveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isSending = true;
      });
      final Url = Uri.https('flutter-prep-9b1cf-default-rtdb.firebaseio.com',
          'shopping - list.json');
      final response = await http.post(Url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': selectedCategory.title,
          }));
      print(response.body);
      print(response.statusCode);
      final Map<String, dynamic> resData = jsonDecode(response.body);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
          id: resData["name"],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: selectedCategory));
    }
  }

  void _Reset() {
    setState(() {
      _formKey.currentState!.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 to 50 characters.';
                  }
                },
                onSaved: (value) {
                  setState(() {
                    _enteredName = value!;
                  });
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number';
                        }
                        onSaved:
                        (value) {
                          setState(() {
                            _enteredQuantity = int.parse(value!);
                          });
                        };
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    value: selectedCategory,
                    items: categories.entries
                        .map(
                          (category) => DropdownMenuItem<Category>(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 1,
                                  height: 1,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (Category? value) {
                      setState(() {
                        selectedCategory =
                            value!; // Update the selected category
                      });
                    },
                    // Set the initially selected category
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                      onPressed: isSending
                          ? null
                          : () {
                              _SaveItem();
                            },
                      child: isSending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator())
                          : const Text('Add'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
