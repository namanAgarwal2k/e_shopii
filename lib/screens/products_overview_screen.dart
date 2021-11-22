// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shopii/providers/cart.dart';
import 'package:e_shopii/providers/products.dart';
import 'package:e_shopii/screens/cart_screen.dart';
import 'package:e_shopii/widgets/app_drawer.dart';
import 'package:e_shopii/widgets/badge.dart';
import 'package:e_shopii/widgets/product_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isInit = true;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts();//won't work.//work if set listen = false.

    //work but's like a hack.
    //  Future.delayed(Duration.zero).then((_){
    //    Provider.of<Products>(context).fetchAndSetProducts();
    //  });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).fetchAndSetProducts();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context,
        listen: false); //false as we just want to use method not data to build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Shopii',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                //set state so that ui is rebuilt when u change it
                if (selectedValue == FilterOptions.Favourites) {
                  //productsContainer.showFavouritesOnly();
                  _showOnlyFavourites = true;
                } else {
                  // productsContainer.showAll();
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}
