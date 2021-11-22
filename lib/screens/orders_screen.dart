// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shopii/providers/orders.dart' show Orders;
import 'package:e_shopii/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _orderFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

//  var _isLoading = false;

  @override
  void initState() {
    _orderFuture = _obtainOrdersFuture();
    //storing our future so that when widget will rebuilt again below than it will
    //not recall future fetch again eg when we add a messenger.

    //  // Future.delayed(Duration.zero).then((_) async {
    // //    setState(() {
    //       _isLoading = true;
    //  //   });
    //  //   await
    //    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_){
    //      setState(() {
    //        _isLoading = false;
    //      });
    //    });
    //       // setState(() {
    //       //   _isLoading = false;
    //       // });
    //  // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);//not needed as it starts a infinite loop as provider calls builder every time.
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error == null) {
                return const Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      orderData.orders[i],
                    ),
                  ),
                );
              }
            }
          },
        ));
  }
}
