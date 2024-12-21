import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin/models/orders_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> orders = [];
  List<OrderModel> get getOrders => orders;

  Future<List<OrderModel>> fetchOrder() async {
    try {
      await FirebaseFirestore.instance.collection('ordersAdvanced').get().then(
        (orderSnapshot) {
          orders.clear();
          for (var element in orderSnapshot.docs) {
            orders.insert(
              0,
              OrderModel(
                orderId: element.get('sharedOrderId'),
                userId: element.get('userId'),
                productId: element.get('productId'),
                productTitle: element.get('productTitle'),
                userName: element.get('userName'),
                price: element.get('price'),
                imageUrl: element.get('imageUrl'),
                quantity: element.get('quantity'),
                orderDate: element.get('orderDate'),
              ),
            );
          }
        },
      );
      return orders;
    } catch (error) {
      rethrow;
    }
  }
}
