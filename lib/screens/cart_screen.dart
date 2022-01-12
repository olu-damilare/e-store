import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart' show Cart;
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/CartItem.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your cart"),),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
            padding: EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text('Total', style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20
    ),),
    Spacer(),
    Chip(label: Text(
        '\$${cart.totalAmount}',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,),
      FlatButton(
        child: Text(
            'Order Now',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: Theme.of(context).primaryColor,
        onPressed: () {
          Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
          cart.clear();
        },
        splashColor: Theme.of(context).accentColor,
      )
    ],
    ),
            ),
    ),
          SizedBox(height: 10),
          Expanded(child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
               id: cart.items.values.toList()[i].id,
               cartItemId: cart.items.keys.toList()[i],
               price: cart.items.values.toList()[i].price,
               quantity: cart.items.values.toList()[i].quantity,
               title: cart.items.values.toList()[i].title,
              ),
          ))
    ],
    ),
    );
  }
}
