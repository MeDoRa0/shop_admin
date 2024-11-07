import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_admin/constants/app_constants.dart';
import 'package:shop_admin/constants/app_validators.dart';
import 'package:shop_admin/models/product_model.dart';
import 'package:shop_admin/providers/image_provider.dart';
import 'package:shop_admin/service/app_methods.dart';
import 'package:shop_admin/widgets/loading_manager.dart';
import 'package:shop_admin/widgets/subtitle_text.dart';
import 'package:shop_admin/widgets/title_text.dart';
import 'package:uuid/uuid.dart';

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
  bool isLoading = false;
  String? productImageUrl;
  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      _categoryValue = widget.productModel!.productCategory;
    }

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
    Provider.of<ImageProviderModel>(context, listen: false).clearImage();
  }

  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    final imageProvider =
        Provider.of<ImageProviderModel>(context, listen: false);
    if (imageProvider.pickedImage == null) {
      AppMethods.errorDialog(
        context: context,
        label: 'please pick image',
        function: () {},
      );
      return;
    }
    if (_categoryValue == null) {
      AppMethods.errorDialog(
          context: context,
          label: 'please select product category',
          function: () {});

      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          isLoading = true;
        });
        //this code to store image on firbase storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('productImage')
            .child('${_titleController.text.trim()}.jpg');
        await ref.putFile(
          File(imageProvider.pickedImage!.path),
        );
        productImageUrl = await ref.getDownloadURL();
        final productID = const Uuid().v4();
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productID)
            .set({
          'productId': productID,
          'productTitle': _titleController.text,
          'productPrice': _priceController.text,
          'productImage': productImageUrl,
          'createdAt': Timestamp.now(),
          'productCategory': _categoryValue,
          'productDescription': _descriptionController.text,
          'productQuantity': _quantityController.text,
        });
        Fluttertoast.showToast(
          backgroundColor: Colors.blue,
          msg: "item has been added",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
        );
        if (!mounted) {
          return;
        }
        await AppMethods.alertOptionalDialog(
          context: context,
          label: 'clear form?',
          function: () {
            clearForm();
          },
        );
      } on FirebaseException catch (error) {
        await AppMethods.errorDialog(
          context: context,
          label: '${error.message}',
          function: () {},
        );
      } catch (error) {
        await AppMethods.errorDialog(
          context: context,
          label: 'an error has been occured $error',
          function: () {},
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && productNetworkImage == null) {
      AppMethods.alertDialog(
          context: context,
          label: 'please upload product image',
          function: () {});

      return;
    }

    if (isValid) {}
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final imageProvider =
        Provider.of<ImageProviderModel>(context, listen: false);
    await AppMethods.imagePickerDialog(
      context: context,
      cameraFT: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.camera);

        if (image != null) {
          imageProvider.setPickedImage(image);
        }
      },
      galleryFT: () async {
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          imageProvider.setPickedImage(image);
        }
      },
      removeFT: () {
        imageProvider.clearImage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: isLoading,
      child: GestureDetector(
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
                    onPressed: () {
                      clearForm();
                    },
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
                  Consumer<ImageProviderModel>(
                    builder: (context, imageProvider, child) {
                      final pickedImage = imageProvider.pickedImage;

                      if (isEditing && productNetworkImage != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            productNetworkImage!,
                            height: size.width * 0.5,
                            alignment: Alignment.center,
                          ),
                        );
                      } else if (pickedImage != null) {
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(pickedImage.path),
                                height: size.width * 0.5,
                                alignment: Alignment.center,
                              ),
                            ),
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
                                    imageProvider.clearImage();
                                  },
                                  child: const Text(
                                    'remove image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return SizedBox(
                          width: size.width * 0.5 + 10,
                          height: size.width * 0.5,
                          child: DottedBorder(
                            color: Colors.blue,
                            radius: const Radius.circular(16),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: localImagePicker,
                                    icon: const Icon(
                                      Icons.image_outlined,
                                      size: 80,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: localImagePicker,
                                    child: const Text('Pick product image'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  DropdownButton(
                    hint: Text(_categoryValue ?? 'Select category'),
                    value: _categoryValue,
                    items: AppConstants.categoriesDropdownList,
                    onChanged: (String? value) {
                      setState(() {
                        _categoryValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
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
                              hintText: 'Product title',
                            ),
                            validator: (value) {
                              return AppValidators.uploadProductTexts(
                                value: value,
                                toBeReturnedString:
                                    "Please enter a valid title",
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                                    ),
                                  ],
                                  key: const ValueKey('Price \$'),
                                  decoration: const InputDecoration(
                                    hintText: 'Price',
                                    prefix: SubTitleText(
                                      label: "\$ ",
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
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
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  key: const ValueKey('Quantity'),
                                  decoration: const InputDecoration(
                                    hintText: 'Quantity',
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
                          const SizedBox(height: 20),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _descriptionController,
                            key: const ValueKey('Description'),
                            maxLength: 800,
                            minLines: 1,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Product description',
                            ),
                            validator: (value) {
                              return AppValidators.uploadProductTexts(
                                value: value,
                                toBeReturnedString: "Description is missed",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
