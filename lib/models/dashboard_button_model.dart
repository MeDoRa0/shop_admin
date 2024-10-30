import 'package:flutter/material.dart';
import 'package:shop_admin/constants/assets.dart';
import 'package:shop_admin/screens/edit_upload_product_form.dart';
import 'package:shop_admin/screens/inner_screens/orders/order_screen.dart';
import 'package:shop_admin/screens/search_screen.dart';

class DashboardButtonModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonModel(
      {required this.text, required this.imagePath, required this.onPressed});

  static List<DashboardButtonModel> dashboardButtonList(BuildContext context) =>
      [
        DashboardButtonModel(
            text: 'Add new product',
            imagePath: Assets.imagesDashboardCloud,
            onPressed: () {
              Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
            }),
        DashboardButtonModel(
            text: 'View all products',
            imagePath: Assets.imagesShoppingCart,
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            }),
        DashboardButtonModel(
            text: 'View orders',
            imagePath: Assets.imagesDashboardOrder,
            onPressed: () {
              Navigator.pushNamed(context, OrderScreen.routName);
            }),
      ];
}
