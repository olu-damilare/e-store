import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier{

  Map<String, CartItem> _items = {};

  Map<String, CartItem>  get items{
    return {..._items};
}

void addItem(String productId, double price, String title){
if(_items.containsKey(productId)){
  _items.update(productId, (existingCartItem) =>
        CartItem(
            existingCartItem.id,
            existingCartItem.title,
            existingCartItem.quantity + 1,
            price));

}else{
  _items.putIfAbsent(productId, () => CartItem(DateTime.now().toString(), title, 1, price));
}
notifyListeners();
}

int get itemCount{
    int sum = 0;
    _items.forEach((_, cartItem) {sum += cartItem.quantity;});
    return sum;
}

double get totalAmount{
    double total = 0.0;
   _items.forEach((key, cartItem) {
     total += cartItem.price * cartItem.quantity;
   });
   return total;
}

void removeCart(String id){
    _items.remove(id);
    notifyListeners();
}

void removeSingleItem(String productId){
if(!_items.containsKey(productId)){
  return;
}
if(_items[productId]!.quantity > 1){
  _items.update(
      productId,
          (existingCartItem) => CartItem(
            existingCartItem.id,
            existingCartItem.title,
            existingCartItem.quantity - 1,
            existingCartItem.price
          ));
}else{
  removeCart(productId);
  return;
}
notifyListeners();
}

void clear(){
    _items.clear();
    notifyListeners();
}

}

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(this.id, this.title, this.quantity, this.price);


}