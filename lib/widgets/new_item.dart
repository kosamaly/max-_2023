import 'dart:convert';

import 'package:flutter/material.dart';
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

  var _enteredQuantity = 1;
  var selectedCategory = categories[Categories.vegetables]!;
  void _SaveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Url = Uri.https('flutter-prep-9b1cf-default-rtdb.firebaseio.com',
          'shopping - list.json');
      http.post(Url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': selectedCategory.title,
          }));
      Navigator.of(context).pop();
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
        title: Text('Form'),
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
                                  width: 16,
                                  height: 16,
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
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _SaveItem();
                      },
                      child: Text('Add'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../data/categories.dart';
// import '../models/category.dart';
//
// class NewItem extends StatefulWidget {
//   const NewItem({Key? key}) : super(key: key);
//
//   @override
//   State<NewItem> createState() => _NewItemState();
// }
//
// class _NewItemState extends State<NewItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Form')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Form(
//           child: Column(children: [
//             TextFormField(
//                 maxLength: 50,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null ||
//                       value.isEmpty ||
//                       int.tryParse(value) == null ||
//                       value.trim().length > 50) {
//                     return 'Must be a valid, positive number.';
//                   }
//                   return "Demo";
//                 }),
//             Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
//               Expanded(
//                 child: TextFormField(
//                     decoration: const InputDecoration(labelText: 'Quantity'),
//                     initialValue: "1",
//                     validator: (value) {
//                       if (value == null ||
//                           value.isEmpty ||
//                           value.trim().length == 1 ||
//                           value.trim().length > 50) {
//                         return 'Must be between 1 to 50 characters.';
//                       }
//                       return "Demo";
//                     }),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               DropdownButton(
//                 items: [
//                   for (final category in categories.entries)
//                     DropdownMenuItem(
//                       value: category.value,
//                       child: Row(children: [
//                         Container(
//                           width: 16,
//                           height: 16,
//                           color: category.value.color,
//                         ),
//                         SizedBox(
//                           width: 6,
//                         ),
//                         Text(category.value.title),
//                       ]),
//                     )
//                 ],
//                 onChanged: (value) {},
//               ),
//             ])
//           ]),
//         ),
//       ),
//     );
//   }
// }
