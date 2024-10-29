import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/constants/theme_data.dart';
import 'package:shop_admin/providers/image_provider.dart';
import 'package:shop_admin/providers/product_provider.dart';
import 'package:shop_admin/providers/theme_provider.dart';
import 'package:shop_admin/screens/dashboard_screen.dart';
import 'package:shop_admin/screens/search_screen.dart';



void main() {
  runApp(const ShopAdmin());
}

class ShopAdmin extends StatelessWidget {
  const ShopAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    //final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
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
                isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            title: 'shop user',
            home: const DashboardScreen(),
           
            routes: {
             
             
            
              
            
             
              
              SearchScreen.routeName: (context) => const SearchScreen(),
            },
          );
        },
      ),
    );
  }
}
