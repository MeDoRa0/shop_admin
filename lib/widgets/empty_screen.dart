

import 'package:flutter/material.dart';
import 'package:shop_admin/widgets/subtitle_text.dart';
import 'package:shop_admin/widgets/title_text.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    super.key,
    required this.imagePath,
    required this.title,
    
   
  });

  final String imagePath, title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: size.height * 0.35,
              width: double.infinity,
            ),
            const TitleText(
              label: 'whoops',
              fontSize: 40,
              color: Colors.red,
            ),
            const SizedBox(
              height: 16,
            ),
            SubTitleText(
              label: title,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 16,
            ),
         
      
          ],
        ),
      ),
    );
  }
}
