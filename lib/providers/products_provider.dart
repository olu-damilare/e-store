import 'package:flutter/foundation.dart';
import 'package:my_shop/providers/product.dart';

class Products with ChangeNotifier{
  List<Product> _items = [

    Product(
      id: "p1",
      title: "Red Shirt",
      desc: "A very nice red shirt",
      price: 2000,
      imageUrl: "https://images.unsplash.com/photo-1608976989382-d913f97920c8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80"
  ),
      Product(
  id: "p2",
  title: "Brogue shoes",
  desc: "A shoe suitable for corporate functions",
  price: 12000,
  imageUrl: "https://images.unsplash.com/photo-1614253429340-98120bd6d753?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=871&q=80"
  ),
  Product(
  id: "p3",
  title: "Yellow scarf",
  desc: "A very fancy scarf",
  price: 1500,
  imageUrl: "https://images.unsplash.com/photo-1536259321887-d64a55cd9ff5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80"
  ),
  Product(
  id: "p4",
  title: "Backpack",
  desc: "An adventurous backpack",
  price: 5000,
  imageUrl: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80"
  )
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

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }
}