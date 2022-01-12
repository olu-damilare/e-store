import 'package:flutter/cupertino.dart';
import 'package:my_shop/providers/cart.dart';

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get allOrders{
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total){
    _orders.insert(0,
        OrderItem(DateTime.now().toString(), total, cartProducts, DateTime.now()));
    notifyListeners();
  }

}

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      this.id,
      this.amount,
      this.products,
      this.dateTime
      );


}