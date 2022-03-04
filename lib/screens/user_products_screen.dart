import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context, listen: false).fetchProducts(true);

  }


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add), onPressed: (){
            Navigator.of(context).pushNamed(EditProductsScreen.routeName);
          },
          )
        ],
      ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
          Center(
            child: CircularProgressIndicator(),
          )
          : RefreshIndicator (
            onRefresh: () => _refreshProducts(context),
            child: Consumer<Products>(
              builder: (ctx, productsData, _) => Padding(
                 padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (_, i) {
                      return Column(
                        children: [
                          UserProductItem(
                            productsData.items[i].id,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl,
                          ),
                          Divider()
                        ],
                      );
                    },),
    ),
            ),
          ),
        ),
    );
  }
}
