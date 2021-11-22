import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shopii/providers/auth.dart';
import 'package:e_shopii/screens/orders_screen.dart';
import 'package:e_shopii/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false, //back button of
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text('Logout'),
            onTap: () {
              //navigator here is used to closed the drawer which remains open after logout showing in debug errors.
              Navigator.of(context).pop();
              // '/' is used to move to main.dart we used it as it will run the home: in main.dart
              // which in the ends moved the user to the auth screen.
              Navigator.of(context).pushReplacementNamed('/');

              //   Navigator.of(context)
              //     .pushReplacementNamed(UserProductScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
