import 'package:e_commerce_app/bottom_nav.dart';
import 'package:e_commerce_app/models/Products.dart';
import 'package:e_commerce_app/pages/product_page.dart';
import 'package:flutter/material.dart';

Route onGenerateRoute(RouteSettings settings){
  switch (settings.name) {
    /*
    case "/login":
      return MaterialPageRoute(builder: (context) => const Login());
    case "/register":
      return MaterialPageRoute(builder: (context) => const Register());
    */
    case "/product_page":
      Product product = settings.arguments as Product;
      return MaterialPageRoute(builder: (context) => ProductPage(product: product));
    case "/homepage":
      return MaterialPageRoute(builder: (context) => const BottomNav());
    default:
     return MaterialPageRoute(
        builder: (context) => Text("404: No route found for path ${settings.name}")
      );
  }
}
