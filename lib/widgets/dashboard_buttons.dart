import 'package:flutter/material.dart';
import 'package:shop_admin/widgets/title_text.dart';

class DashboardButtons extends StatelessWidget {
  const DashboardButtons(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.onPressed});

  final String title, imagePath;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 65,
              width: 65,
            ),
            const SizedBox(
              height: 16,
            ),
            TitleText(label: title),
          ],
        ),
      ),
    );
  }
}
