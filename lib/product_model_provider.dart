import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
   int? id ;
   String? title;
   String? description;
   double? price;
   String? imageUrl;


  ProductModel({
     required this.id ,
     this.title,
     this.description,
     this.price,
     this.imageUrl,

  });
  ProductModel.fromDocumentSnapshot( DocumentSnapshot documentSnapshot) {
    id = documentSnapshot['id'];
    title = documentSnapshot["title"];
    description = documentSnapshot["description"];
    price = documentSnapshot["price"];
    imageUrl = documentSnapshot["imageUrl"];

  }
}
