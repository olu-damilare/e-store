import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFavourite = false;

  Product({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.imageUrl,
  }
    );

  void toggleFavouriteStatus(){
    isFavourite = !isFavourite;
    notifyListeners();
  }
}