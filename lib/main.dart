// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shopii/providers/auth.dart';
import 'package:e_shopii/providers/cart.dart';
import 'package:e_shopii/providers/orders.dart';
import 'package:e_shopii/providers/products.dart';
import 'package:e_shopii/screens/auth_screen.dart';
import 'package:e_shopii/screens/cart_screen.dart';
import 'package:e_shopii/screens/edit_product_screen.dart';
import 'package:e_shopii/screens/orders_screen.dart';
import 'package:e_shopii/screens/products_detail_screen.dart';
import 'package:e_shopii/screens/products_overview_screen.dart';
import 'package:e_shopii/screens/splash_screen.dart';
import 'package:e_shopii/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        // or not recommended way like
        // ChangeNotifierProvider.value(
        //   value: Products(),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        //ChangeNotifierProvider.value(value: Orders(),)
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],

      // ChangeNotifierProvider(
      //   create: (ctx) => Products(),
      // _ child widget which is the static part which you don't want to rebuild.
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.amber,
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          //  : ProductsOverviewScreen(),
                          : AuthScreen(),
                  //passes Splash Screen if waiting is done moved to auth screen.
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
