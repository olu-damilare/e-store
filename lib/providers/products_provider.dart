import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:my_shop/providers/product.dart';

class Products with ChangeNotifier{
  List<Product> _items = [

  //   Product(
  //     id: "p1",
  //     title: "Red Shirt",
  //     desc: "A very nice red shirt",
  //     price: 2000,
  //     imageUrl: "https://images.unsplash.com/photo-1608976989382-d913f97920c8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80"
  // ),
  //     Product(
  // id: "p2",
  // title: "Brogue shoes",
  // desc: "A shoe suitable for corporate functions",
  // price: 12000,
  // imageUrl: "https://images.unsplash.com/photo-1614253429340-98120bd6d753?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=871&q=80"
  // ),
  // Product(
  // id: "p3",
  // title: "Yellow scarf",
  // desc: "A very fancy scarf",
  // price: 1500,
  // imageUrl: "https://images.unsplash.com/photo-1536259321887-d64a55cd9ff5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80"
  // ),
  // Product(
  // id: "p4",
  // title: "Backpack",
  // desc: "An adventurous backpack",
  // price: 5000,
  // imageUrl: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80"
  // )
  ];

  bool _showFavouritesOnly = false;

  List<Product> get items {
    // if(_showFavouritesOnly){
    //   return _items.where((item) => item.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouritesItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  // void addProduct(Product product){
  //   _items.add(product);
  //   notifyListeners();
  // }
  //
  // void showFavouritesOnly(){
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  void showAll(){
    _showFavouritesOnly = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async{
    const url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/products.json';
    try {
     final response = await post(Uri.parse(url), body: json.encode({
       'title': product.title,
       'description': product.desc,
       'imageUrl': product.imageUrl,
       'price': product.price,
       'isFavourite': product.isFavourite
     })
     );



     final newProduct = Product(
         title: product.title,
         desc: product.desc,
         imageUrl: product.imageUrl,
         price: product.price,
         id: json.decode(response.body)['name']
     );
     _items.add(newProduct);
     notifyListeners();
   }catch(error){
     print(error);
     throw error;
   }


  }

  Future<void> fetchProducts() async{
    const url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/products.json';

    try {
      final response = await get(Uri.parse(url));
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      fetchedData.forEach((id, data){
        loadedProducts.add(Product(
          id: id,
          title: data['title'],
          desc: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          isFavourite: data['isFavourite']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
      print(json.decode(response.body));
    }catch(error){
      // throw error;
    }
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex =_items.indexWhere((prod) => (prod.id == id));
    if(prodIndex >= 0) {
      final url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/products/$id.json';
      try {
        await patch(Uri.parse(url), body: json.encode({
          'title': newProduct.title,
          'description': newProduct.desc,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }

  }

  void deleteProduct(String id){
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }


}