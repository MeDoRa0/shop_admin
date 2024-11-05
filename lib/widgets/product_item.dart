import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/providers/product_provider.dart';
import 'package:shop_admin/screens/edit_upload_product_form.dart';
import 'package:shop_admin/widgets/subtitle_text.dart';
import 'package:shop_admin/widgets/title_text.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.productID});
  final String productID;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final getCurrentProduct = productProvider.findByProdId(productID);

    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditOrUploadProductScreen(
                    productModel: getCurrentProduct,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  FancyShimmerImage(
                    imageUrl: getCurrentProduct.productImage,
                    width: double.infinity,
                    height: size.height * 0.22,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TitleText(
                          label: getCurrentProduct.productTitle,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SubTitleText(
                            label: '${getCurrentProduct.productPrice}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
