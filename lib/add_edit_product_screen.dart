
// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:admin_store/product_model_provider.dart';
import 'package:admin_store/products_provider.dart';
import 'package:admin_store/ui_spacing_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_db.dart';
class AddEditProductScreen extends StatefulWidget {
    var productId;
   final ProductModel? productModel;
   AddEditProductScreen({super.key,required this.productId, this.productModel, });
  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController titles = TextEditingController();
  TextEditingController prices = TextEditingController();
  TextEditingController descriptions = TextEditingController();
  TextEditingController image = TextEditingController();
  String? title, description, imageUrl;
  double? price;
  ProductModel? _product;
  var _isLoaded = false;
  int? id ;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _submitForm() async{
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoaded = true;
    });
    if (widget.productId != 'add') {
      // UPDATE PRODUCT
      setState(() {
        _isLoaded = false;
      });
      final product = ProductModel(
          id: widget.productModel!.id,
          title: widget.productModel!.title,
          price: widget.productModel!.price,
          imageUrl: widget.productModel!.imageUrl,
          description: widget.productModel!.description
      );
      await FirebaseDb.updateStatus(true,product);
      titles.clear();
      prices.clear();
      descriptions.clear();
      _imageUrlController.clear();
      setData();
    } else {
      setState(() {
        _isLoaded = false;
      });
      final product = ProductModel(
        id: id!,
        title: titles.text,
        price: double.parse(prices.text),
        imageUrl: _imageUrlController.text,
        description: descriptions.text
      );
      await FirebaseDb.addProduct(product);
      titles.clear();
      prices.clear();
      descriptions.clear();
      _imageUrlController.clear();
    }


  }

  @override
  Widget build(BuildContext context) {
    if (widget.productId != 'add') {
      // Because i user controller for image TEXTFIELDFORM
      _imageUrlController.text = _product!.imageUrl!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Edit Product'),
      ),
      body: _isLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller:  titles,
                        // initialValue:
                        //     widget.productId != 'add' ? _product!.title : '',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: 'Title',
                          hintStyle: Theme.of(context).textTheme.bodyText1,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          title = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title';
                          }
                          return null; // null mean no error
                        },
                      ),
                      UISpacingHelper.verticalSpaceSmall,
                      TextFormField(
                        controller: prices,
                        // initialValue: widget.productId != 'add'
                        //     ? _product!.price.toString()
                        //     : '',
                        focusNode: _priceFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: 'Price',
                          hintStyle: Theme.of(context).textTheme.bodyText2,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          price = double.parse(value!);
                        },
                      ),
                      UISpacingHelper.verticalSpaceSmall,
                      TextFormField(
                        controller: descriptions,
                        // initialValue: widget.productId != 'add'
                        //     ? _product!.description
                        //     : '',
                        focusNode: _descriptionFocusNode,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          hintText: 'description',
                          hintStyle: Theme.of(context).textTheme.bodyLarge,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          description = value;
                        },
                      ),
                      UISpacingHelper.verticalSpaceSmall,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(

                              controller: _imageUrlController,
                           //   focusNode: _imageUrlFocusNode,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: 'Image Url',
                                hintStyle: Theme.of(context).textTheme.bodyText2,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                _submitForm();
                              },
                              onSaved: (value) {
                                imageUrl = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      UISpacingHelper.verticalSpaceMedium,
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: ElevatedButton(
                         // colo: Colors.orange,
                          onPressed: _submitForm,
                          child: Text(
                            widget.productId != 'add' ? 'Save' : 'Add',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      UISpacingHelper.verticalSpaceMedium,
                      _btnDelete(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _btnDelete() {
    if (widget.productId != 'add') {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {

            Navigator.of(context).pop();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
  Future<void> setData() async {
    CollectionReference mobiles = FirebaseFirestore.instance.collection('mobiles');
    mobiles.add({
      'title': titles.text,
      'price': prices.text,
      'description': descriptions.text,
      'imageUrl': _imageUrlController.text,
    }).then((value) {
      print("=================================== User Added $value");
      Navigator.of(context).pop();
      // Get.offAll(() => const SharedBottomAppBar());
    }).catchError((error) {
      print("================================= Failed to add user: $error");
    });
  }
}
