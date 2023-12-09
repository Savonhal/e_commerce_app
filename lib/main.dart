import 'package:e_commerce_app/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_commerce_app/firebase_options.dart';

import 'package:e_commerce_app/on_generate_routes.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: onGenerateRoute,
      home: SplashScreen()
    );
  }
}
