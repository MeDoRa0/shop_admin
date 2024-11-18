import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/constants/assets.dart';
import 'package:shop_admin/models/dashboard_button_model.dart';
import 'package:shop_admin/providers/theme_provider.dart';
import 'package:shop_admin/widgets/dashboard_buttons.dart';
import 'package:shop_admin/widgets/title_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
   // final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const TitleText(label: 'Dashboard'),
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(Assets.imagesShoppingCart),
          ),
          actions: [
            IconButton(
              onPressed: () {
                themeProvider.setDarkTheme(
                    themeValue: !themeProvider.getIsDarkTheme);
              },
              icon: Icon(themeProvider.getIsDarkTheme
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: DashboardButtons(
                title: DashboardButtonModel.dashboardButtonList(context)[index]
                    .text,
                imagePath:
                    DashboardButtonModel.dashboardButtonList(context)[index]
                        .imagePath,
                onPressed: () {
                  DashboardButtonModel.dashboardButtonList(context)[index]
                      .onPressed();
                },
              ),
            ),
          ),
        ));
  }
}
