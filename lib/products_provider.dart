import 'package:admin_store/firebase_db.dart';
import 'package:admin_store/product_model_provider.dart';
import 'package:get/get.dart';
class ProductsController extends GetxController {

  Rx<List<ProductModel>> productList = Rx<List<ProductModel>>([]);
  List<ProductModel> get product => productList.value;

  @override
  void onReady() {
    productList.bindStream(FirebaseDb.productStream());
  }

}
