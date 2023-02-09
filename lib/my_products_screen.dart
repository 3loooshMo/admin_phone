import 'package:admin_store/products_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_edit_product_screen.dart';

class MyProductsScreen extends StatelessWidget {
   MyProductsScreen({super.key});
   ProductsController productController = Get.put(ProductsController());
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
      ),
      body: Stack(
        children: <Widget>[
          Obx(
            () {
              return Container(
                child: ListView.builder(
                  itemCount: productController.product.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("==============================${productController.product[index].price}");
                    final _product = productController.product[index];
                    return
                    ListTile(
                          title: Text(_product.title.toString(), style: Theme.of(context).textTheme.subtitle1),
                          subtitle: Text(
                            _product.description.toString(),
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[500],
                            ),
                          ),
                          leading: CircleAvatar(

                            backgroundImage: NetworkImage(_product.imageUrl.toString()),
                            radius: 33,
                          ),
                          trailing: Text(
                            _product.price.toString(),
                          ),
                          onTap: () {
                            // Go to edit product
                            Get.to(()=>AddEditProductScreen(productId: '',productModel: _product,));
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(builder: (_) => ));
                          },
                        );
                  },
                ),
              );
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
                // color: Theme.of(context).accentColor,
                onPressed: () {
                  // Go to add product
                  Get.to(()=> AddEditProductScreen(productId: "add",));

                },
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
