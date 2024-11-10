import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/constants/theme_data.dart';
import 'package:shop_admin/providers/image_provider.dart';
import 'package:shop_admin/providers/product_provider.dart';
import 'package:shop_admin/providers/theme_provider.dart';
import 'package:shop_admin/screens/dashboard_screen.dart';
import 'package:shop_admin/screens/edit_upload_product_form.dart';
import 'package:shop_admin/screens/inner_screens/orders/order_screen.dart';
import 'package:shop_admin/screens/search_screen.dart';

void main() {
  runApp(const ShopAdmin());
}

class ShopAdmin extends StatelessWidget {
  const ShopAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Scaffold(
                body: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: SelectableText(
                      'an error has been occured ${snapshot.error}'),
                ),
              );
            }
          return
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ThemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProductProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ImageProviderModel(),
              ),
            ],
            //we can use Consumer to use ThemePovider
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  title: 'shop user',
                  home: const DashboardScreen(),
                  routes: {
                    SearchScreen.routeName: (context) => const SearchScreen(),
                    OrderScreen.routName: (context) => const OrderScreen(),
                    EditOrUploadProductScreen.routeName: (context) =>
                        const EditOrUploadProductScreen(),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
