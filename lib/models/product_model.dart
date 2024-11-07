import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String productID,
      productCategory,
      productTitle,
      productDescription,
      productImage,
      productQuantity;
  final double productPrice;
  Timestamp? createdAt;

  ProductModel(
      {required this.productID,
      required this.productCategory,
      required this.productTitle,
      required this.productDescription,
      required this.productImage,
      required this.productQuantity,
       this.createdAt,
      required this.productPrice});
}
