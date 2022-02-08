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
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchProducts();
   //
   // Future.delayed(Duration.zero).then((value) {
   //   Provider.of<Products>(context).fetchProducts();
   // });
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(_isInit){
      _isLoading = true;
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
        body: _isLoading ? Center(
          child: CircularProgressIndicator(),
        )
        : ProductsGrid(_showOnlyFavourites)
    );
  }
}


