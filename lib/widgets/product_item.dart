import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {

  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // const ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
   final product =  Provider.of<Product>(context, listen: false);
   final cart = Provider.of<Cart>(context, listen: false);
   final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child:GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName, arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/[rpdict-placejolder.png'),

                image: NetworkImage(
                    product.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            )
          ),
            footer: GridTileBar(
              leading:
    Consumer<Product>(
    builder: (ctx, product, _) =>  IconButton(
                  icon: Icon(product.isFavourite ?
                      Icons.favorite : Icons.favorite_border_sharp
                  ),
                onPressed: () {
                    product.toggleFavouriteStatus(authData.token as String, authData.userId as String);
                },
                color: Theme.of(context).accentColor,
              ),
          ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Added item to cart", textAlign: TextAlign.center,),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: (){
                            cart.removeSingleItem(product.id);
                          },
                        ),
                        backgroundColor: Theme.of(context).accentColor,
                      ));
                },
                color: Theme.of(context).accentColor,
              ),
              backgroundColor: Colors.black54,
                title: Text(product.title, textAlign: TextAlign.center,)),
      ),
    );
  }
}
