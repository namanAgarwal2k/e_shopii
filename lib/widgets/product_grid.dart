// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:e_shopii/providers/products.dart';
import 'package:e_shopii/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs ? productsData.favouriteItems : productsData.items;
    //above we are calling getter of items list with Provider object help.
    return GridView.builder(
      padding: const EdgeInsets.all(10.0), // const for not letting it rebuild
      itemCount: products.length, // tells gridView how many grid items to build
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        //value approach is recommended here when we reuse existing object or used grid or list.
        //create: (c) => products[i], //builder built my product object
        //products[i] will return a single product item as it stored in product class.
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl
            ),
      ), //holds builder function , i => item
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //amounts of colums i want a have
          childAspectRatio: 2 / 2.6,
          crossAxisSpacing: 10,
          mainAxisSpacing:
              10), //or FixedExtent which build as many colums ,here it squezes the view as per requirements
    );
  }
}
