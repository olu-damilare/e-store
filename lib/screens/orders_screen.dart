import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/ordered_Item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {

  static const routeName =  '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
   print('building orders');
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, data) {
         if(data.connectionState == ConnectionState.waiting){
           return Center(
               child: CircularProgressIndicator()
           );
         }else{
           if(data.error != null){
              return AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: [
                  FlatButton(onPressed: (){
                    Navigator.of(ctx).pop();
                  },
                      child: Text('Okay')
                  )
                ],
              );
           }else{
              return Consumer<Orders>(builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.allOrders.length,
                itemBuilder: (ctx, i) => OrderedItem(orderData.allOrders[i]),
              )
              );
           }
         }
        })
    );
  }
}
