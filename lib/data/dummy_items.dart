import '../models/category.dart';
import '../models/grocery_item.dart';
import 'categories.dart';

final groceryItems = [
  GroceryItem(
    id: 'a',
    name: 'milk',
    quantity: 1,
    category: categories[Categories.dairy]??,
  ),
  GroceryItem(
    id: 'b',
    name: 'bananas',
    quantity: 5,
    category: categories[categories.fruit],
  ),
  GroceryItem(
    id: 'c',
    name: 'beef steak',
    quantity: 1,
    category: categories[categories.meat]  ,
  ),
];
