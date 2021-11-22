// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

//THIS SCREEN SHOWS DETAILS OF IMAGE
class ProductDetailScreen extends StatelessWidget {
  // final String title;
  //
  // ProductDetailScreen(this.title);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    //this is getting item with id and comparing it and than loading in loadedProduct.
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 500,
                width: double.infinity,
                child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ], //soft wrap wrap in lines if there is no more space.
          ),
        ));
  }
}
