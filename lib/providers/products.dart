// @dart=2.9

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_shopii/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //       id: 'p1',
    //       title: 'RedShirt',
    //       description: 'A red shirt',.
    //       price: 29.99,
    //       imageUrl:
    //           'https://rukminim1.flixcart.com/image/714/857/jiyvvrk0/shirt/g/v/r/40-bs-ns-002-bs-fashion-original-imaf4zyuppecyhbd.jpeg?q=50'),
    //   Product(
    //       id: 'p2',
    //       title: 'jeans',
    //       description: 'A jeans',
    //       price: 59.99,
    //       imageUrl:
    //           'https://5.imimg.com/data5/AL/RS/MY-2325220/men-ankle-length-jeans-500x500.jpg'),
  ];

  //var _showFavouritesOnly = false;
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filterByUser = true]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shopii-58c7a-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString'); //?auth=...');
    //... represent token in firebase.Here checking authentication.

    //we use this url to fetch from correct product and they are stored in this url.
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      url = Uri.parse(
          'https://shopii-58c7a-default-rtdb.firebaseio.com/$userId.json?auth=$authToken');

      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      print(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    //void as don't want any data back to our widget
    final url = Uri.parse(
        'https://shopii-58c7a-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    //return http.
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
          //  'isFavourite': product.isFavourite
        }),
      );

      //  .then(
      //   (response) {
      //   print(json.decode(response.body)); //gives name: some special id

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
        //name as it decodes in name variable remember the master.
        //id: DateTime.now().toString(),
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct);//at the start of list
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // )
  //   .catchError((error) {
  //   print(error);
  //   throw error;
  // });

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      //id is added as we are updating a specific product.
      final url = Uri.parse(
          'https://shopii-58c7a-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      //**CAN ADD TRY AND CATCH HERE FOR ERROR HANDLING**//
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }),
      );
      //patch is used to update that data in firebase
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shopii-58c7a-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url); //.then((response) {
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    //otherwise it will reset the existing product if error is not catched.
    existingProduct = null;
    // }).catchError((_) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    // });
    // _items.removeAt(existingProductIndex);
    // notifyListeners();
  }
}
//.then - when success
//otherwise move to catch error
//
