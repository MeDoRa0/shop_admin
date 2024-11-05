import 'package:flutter/material.dart';

class AppConstants {
  static const String productImageUrl =
      'https://th.bing.com/th/id/R.77eed415b01a3ec4f6cb7758a5a2a6d4?rik=XKDGn49n844u4Q&riu=http%3a%2f%2fpluspng.com%2fimg-png%2fshoes-png-nike-shoes-transparent-background-800.png&ehk=ZvKLgGJIAl%2fJYtcu4emEZimity8VBQnk3UNcaW8MbLQ%3d&risl=&pid=ImgRaw&r=0';

  static List<String> categoriesList = [
    'Phones',
    'Clothes',
    'Beauty',
    'Shoes',
    'Funiture',
    'Watches',
    'Laptops',
    'Electronics',
    'Books',
    'Cosmetics',
    'Accessories',
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropdownList {
    List<DropdownMenuItem<String>>? menueItems =
        List<DropdownMenuItem<String>>.generate(
      categoriesList.length,
      (index) => DropdownMenuItem(
        value: categoriesList[index],
        child: Text(
          categoriesList[index],
        ),
      ),
    );
    return menueItems;
  }
}
