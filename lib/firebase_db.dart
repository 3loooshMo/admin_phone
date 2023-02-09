import 'package:admin_store/product_model_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'const.dart';


class FirebaseDb {
  static addProduct(ProductModel productModel) async {
    await firebaseFirestore
        .collection('products_mobile')
        .add({
      'title': productModel.title,
      'description': productModel.description,
      'imageUrl': productModel.imageUrl,
      'price': productModel.price,
      'id': productModel.id,
      'isDone': false,
    });
  }

  static Stream<List<ProductModel>> productStream() {
    return firebaseFirestore
        .collection('products_mobile')
        .snapshots()
        .map((QuerySnapshot query) {
      List<ProductModel> productMobile = [];
      for (var product in query.docs) {
        final products = ProductModel.fromDocumentSnapshot(product);
        productMobile.add(products);
      }
      return productMobile;
    });
  }

  static updateStatus(bool isDone, documentId) {
    firebaseFirestore
        .collection('products_mobile')
        .doc(documentId)
        .update(
      {
        'isDone': isDone,
      },
    );
  }
  static deleteTodo(String documentId) {
    firebaseFirestore
        .collection('products_mobile')
        .doc(documentId)
        .delete();
  }
}