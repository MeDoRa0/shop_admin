import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_admin/constants/app_constants.dart';
import 'package:shop_admin/constants/app_validators.dart';
import 'package:shop_admin/models/product_model.dart';
import 'package:shop_admin/service/app_methods.dart';
import 'package:shop_admin/widgets/subtitle_text.dart';
import 'package:shop_admin/widgets/title_text.dart';

class EditOrUploadProductScreen extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';

  const EditOrUploadProductScreen({
    super.key,
    this.productModel,
  });
  final ProductModel? productModel;

  @override
  State<EditOrUploadProductScreen> createState() =>
      _EditOrUploadProductScreenState();
}

class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isEditing = false;
  String? productNetworkImage;

  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;
  String? _categoryValue;
  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      _categoryValue = widget.productModel!.productCategory;
    }
    // _categoryController = TextEditingController();
    // _brandController = TextEditingController();
    // ?. is an introgation mark it used to use value if it iis not null
    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController = TextEditingController(
        text: widget.productModel?.productPrice.toString());
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quantityController =
        TextEditingController(text: widget.productModel?.productQuantity);

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    removePickedImage();
  }

  void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }

  Future<void> _uploadProduct() async {
    if (_categoryValue == null) {
      AppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: 'please select product category',
          fct: () {});

      return;
    }
    if (_pickedImage == null) {
      AppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: 'please upload product image',
          fct: () {});

      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {}
  }

  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && productNetworkImage == null) {
      AppMethods.showErrorORWarningDialog(
          context: context,
          subtitle: 'please upload product image',
          fct: () {});

      return;
    }

    if (isValid) {}
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await AppMethods.imagePickerDialog(
      context: context,
      cameraFT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        //the bottomsheet make this widget appear in bottom of screen
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Clear",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    // backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  icon: Icon(isEditing ? Icons.edit : Icons.add_box_rounded),
                  label: Text(
                    isEditing ? 'edit product' : 'add new product',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (isEditing) {
                      _editProduct();
                    } else {
                      _uploadProduct();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TitleText(
              label: isEditing ? 'Edit this product' : 'Add new product'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (isEditing && productNetworkImage != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      productNetworkImage!,
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  ),
                ] else if (_pickedImage == null) ...[
                  SizedBox(
                    width: size.width * 0.5 + 10,
                    height: size.width * 0.5,
                    child: DottedBorder(
                      color: Colors.blue,
                      radius: const Radius.circular(16),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                localImagePicker();
                              },
                              icon: const Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.blue,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                localImagePicker();
                              },
                              child: const Text('pick product image'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_pickedImage!.path),
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
                if (_pickedImage != null && productNetworkImage != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          localImagePicker();
                        },
                        child: const Text('pick another image'),
                      ),
                      TextButton(
                        onPressed: () {
                          removePickedImage();
                        },
                        child: const Text(
                          'remove image',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
                const SizedBox(
                  height: 25,
                ),
                DropdownButton(
                  //if catrgory is null show the the text
                  hint: Text(_categoryValue ?? 'select category'),
                  value: _categoryValue,
                  items: AppConstants.categoriesDropdownList,
                  onChanged: (String? value) {
                    setState(() {
                      _categoryValue = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          key: const ValueKey('Title'),
                          maxLength: 80,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'Product Title',
                          ),
                          validator: (value) {
                            return AppValidators.uploadProductTexts(
                              value: value,
                              toBeReturnedString: "Please enter a valid title",
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _priceController,
                                key: const ValueKey('Price \$'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                    filled: true,
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: 'Price',
                                    prefix: SubTitleText(
                                      label: "\$ ",
                                      color: Colors.blue,
                                      fontSize: 16,
                                    )),
                                validator: (value) {
                                  return AppValidators.uploadProductTexts(
                                    value: value,
                                    toBeReturnedString: "Price is missing",
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                key: const ValueKey('Quantity'),
                                decoration: const InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'Qty',
                                ),
                                validator: (value) {
                                  return AppValidators.uploadProductTexts(
                                    value: value,
                                    toBeReturnedString: "Quantity is missed",
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          key: const ValueKey('Description'),
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: 8,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            filled: true,
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'Product description',
                          ),
                          validator: (value) {
                            return AppValidators.uploadProductTexts(
                              value: value,
                              toBeReturnedString: "Description is missed",
                            );
                          },
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom > 0.0
                      ? 10
                      : kBottomNavigationBarHeight + 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
