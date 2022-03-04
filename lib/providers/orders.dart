import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:my_shop/providers/cart.dart';

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get allOrders{
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await get(Uri.parse(url));
    final List<OrderItem> fetchedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;

    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, data) {
      fetchedOrders.add(
          OrderItem(
              id: orderId,
              amount: data['amount'],
              products: (data['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                        item['id'],
                        item['title'],
                        item['quantity'],
                        item['price'],
                  )
                ).toList(),
            dateTime: DateTime.parse(data['dateTime'])


      ));
    });
    _orders = fetchedOrders.reversed.toList();
    notifyListeners();

  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async{
    final url = 'https://flutter-project-4fd4f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
   final timeStamp = DateTime.now();
    final response = await post(Uri.parse(url), body: json.encode({
    'amount': total,
    'dateTime': timeStamp.toIso8601String(),
    'products': cartProducts.map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price
      }).toList()
   }));
    _orders.insert(0,
        OrderItem(id: json.decode(response.body)['name'], amount: total, products: cartProducts, dateTime: timeStamp));
    notifyListeners();
  }

}

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime
  });


}