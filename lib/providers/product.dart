import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

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
    this.isFavourite = false
  }
    );

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token, String userId) async{
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try {
     final response = await put(Uri.parse(url), body: json.encode(
        isFavourite
      ));

     if(response.statusCode >= 400){
       _setFavValue(oldStatus);
     }
    }catch(error){
      _setFavValue(oldStatus);
    }
    
  }
}