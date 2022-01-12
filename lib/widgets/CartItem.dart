import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
final String id;
final double price;
final int quantity;
final String title;
final String cartItemId;

  const CartItem({required this.id, required this.price, required this.quantity, required this.title, required this.cartItemId});



  @override
  Widget build(BuildContext context) {

    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure you want to delete this item?"),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              FlatButton(child: Text('No'),
                onPressed:() {
                  Navigator.of(ctx).pop(false);
              },),
              FlatButton(child: Text('Yes'), onPressed:() {
                Navigator.of(ctx).pop(true);

              },),
            ],
          )
        );
      },
      onDismissed: (direction){
        Provider.of<Cart>(context, listen: false).removeCart(cartItemId);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white,size: 40,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 4,
      ),
      ),
      child: Card(margin: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              )
            ),
            title: Text(title),
            subtitle: (Text('Total: \$${(price * quantity)}')),
            trailing: Text('$quantity x'),
          )
        ),
      ),
    );
  }
}
