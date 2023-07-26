import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Your Groceries'),
      ),
      body: ListView.builder(itemBuilder: (context, index) => ListTile()),
    );
  }
}
