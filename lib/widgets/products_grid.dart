import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFaves;

  ProductsGrid(this.showFaves);


  @override
  Widget build(BuildContext context) {
   final products = Provider.of<Products>(context);
   final selectedProducts = showFaves ? products.favouritesItems : products.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: selectedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(

        value: selectedProducts[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20
      ),
    );
  }
}