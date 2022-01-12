import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/ordered_Item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {

  static const routeName =  '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.allOrders.length,
          itemBuilder: (ctx, i) => OrderedItem(orderData.allOrders[i]),
      ),
    );
  }
}
