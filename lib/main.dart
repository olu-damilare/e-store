import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_shop/helpers/custom_route.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/screens/product_overview_screen.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:my_shop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers: [
      ChangeNotifierProvider.value(
        value: Auth(),
      ),
      ChangeNotifierProxyProvider<Auth, Products>(
      update:  (ctx, auth, previousProducts) => Products(
          auth.token,
          auth.userId.toString(),
          previousProducts == null ? [] : previousProducts.items
      ),
      create: (BuildContext context) => Products(null, '', []),
      ),
      ChangeNotifierProvider(
        create: (BuildContext context) => Cart(),
      ),
      ChangeNotifierProxyProvider<Auth, Orders>(
        update:  (ctx, auth, previousOrders) => Orders(auth.token.toString(), auth.userId.toString(), previousOrders == null ? [] : previousOrders.allOrders),
        create: (BuildContext context) => Orders('', '', []),
      )

    ],
      child: Consumer<Auth>(builder: (ctx, auth, _) => MaterialApp(
        title: 'Slim Daddy\'s shop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: 'Abhaya',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android : CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder()
            }
          )
        ),
        home: auth.isAuth
            ? ProductOverviewScreen()
            : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState == ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen(),

               ) ,
        routes:  {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductsScreen.routeName: (ctx) => EditProductsScreen()

        },
      ),)
    );
  }
}



