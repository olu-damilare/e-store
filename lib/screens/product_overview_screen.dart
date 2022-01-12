import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/badge.dart';
import 'package:my_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';


enum FilterOptions{
  Favorites, All
}

class ProductOverviewScreen extends StatefulWidget {


  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  bool _showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    // final products =  Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Slim daddy's shop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                if(selectedValue == FilterOptions.Favorites){
                  _showOnlyFavourites = true;
                }else{
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Only Favourites'), value: FilterOptions.Favorites),
                PopupMenuItem(child: Text('Show all'), value: FilterOptions.All),
              ]),
          Consumer<Cart>(
            builder: (_, cart, __) => Badge(
            child: IconButton(
                  icon:Icon(Icons.shopping_cart),
                  onPressed: (){
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
            ),
              value: cart.itemCount.toString(),
            ),
          )
        ],
      ),
        drawer: AppDrawer(),
        body: ProductsGrid(_showOnlyFavourites)
    );
  }
}


