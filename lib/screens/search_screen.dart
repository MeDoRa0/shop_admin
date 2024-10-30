import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/models/product_model.dart';
import 'package:shop_admin/providers/product_provider.dart';
import 'package:shop_admin/widgets/product_item.dart';
import 'package:shop_admin/widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/searchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productList = passedCategory == null
        ? productProvider.getProducts
        : productProvider.findByCategory(categoryName: passedCategory);

    return GestureDetector(
      onTap: () {
        //this widget will enable the user to exit textfield if he press on screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitleText(
            label: passedCategory ?? 'Search',
          ),
        ),
        body: productList.isEmpty
            ? const Center(
                child: TitleText(label: 'No product found'),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                        hintText: 'search',
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // setState(() {
                            searchTextController.clear();
                            FocusScope.of(context).unfocus();

                            //});
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          productListSearch = productProvider.searchQuery(
                              searchText: searchTextController.text,
                              passedList: productList);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (searchTextController.text.isNotEmpty &&
                        productListSearch.isEmpty) ...[
                      const Center(
                        child: TitleText(
                          label: 'no result found',
                          fontSize: 40,
                        ),
                      ),
                    ],
                    Expanded(
                      child: DynamicHeightGridView(
                        itemCount: searchTextController.text.isNotEmpty
                            ? productListSearch.length
                            : productList.length,
                        builder: ((context, index) {
                          return ProductItem(
                            productID: searchTextController.text.isNotEmpty
                                ? productListSearch[index].productID
                                : productList[index].productID,
                          );
                        }),
                        crossAxisCount: 2,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
