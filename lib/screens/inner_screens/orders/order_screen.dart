
import 'package:flutter/material.dart';
import 'package:shop_admin/constants/assets.dart';
import 'package:shop_admin/screens/inner_screens/orders/order_widget.dart';
import 'package:shop_admin/widgets/empty_screen.dart';
import 'package:shop_admin/widgets/title_text.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  static const routName = '/OrderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isEmptyOrder = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleText(label: 'placed orders'),
      ),
      body: isEmptyOrder
          ?  const EmptyScreen(
              imagePath: Assets.imagesDashboardOrder,
              title: 'no have no order',
              subtilte: 'go shop and order awesome items',
              buttonText: 'shop now')
          : ListView.separated(
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: OrderWidget(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 10,
                );
              },
              itemCount: 10),
    );
  }
}
