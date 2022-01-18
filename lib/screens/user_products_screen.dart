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
        body: Padding(
           padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    UserProductItem(
                      productsData.items[i].title,
                      productsData.items[i].imageUrl,
                    ),
                    Divider()
                  ],
                );
              },),
    ),
    );
  }
}
