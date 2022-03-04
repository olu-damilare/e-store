import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:my_shop/models/http_exception.dart';
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
  String? authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if(_showFavouritesOnly){
    //   return _items.where((item) => item.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouritesItems {
    return _items.where((item) => item.isFavourite).toList();
  }


  void showAll(){
    _showFavouritesOnly = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async{
    final url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
     final response = await post(Uri.parse(url), body: json.encode({
       'title': product.title,
       'description': product.desc,
       'imageUrl': product.imageUrl,
       'price': product.price,
       'creatorId': userId
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

  Future<void> fetchProducts([bool filterByUser = false]) async{
   final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await get(Uri.parse(url));
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      if(fetchedData.isEmpty){
        return;
      }
      url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken';

      final favouriteResponse = await get(Uri.parse(url));
      final favouriteData = json.decode(favouriteResponse.body);

      final List<Product> loadedProducts = [];
      // print(fetchedData);
      fetchedData.forEach ((id, data){
        loadedProducts.add(Product(
          id: id,
          title: data['title'],
          desc: data['description'],
          price: data['price'],
          isFavourite: favouriteData == null ? false : data['imageUrl'] ?? false,
          imageUrl: data['imageUrl']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
      // print(json.decode(response.body));
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
      final url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
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

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    dynamic existingProduct = _items[existingProductIndex];
    final response = await delete(Uri.parse(url));

    _items.removeAt(existingProductIndex);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct!);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;

  }


}