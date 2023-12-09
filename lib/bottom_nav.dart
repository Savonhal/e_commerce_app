import 'package:e_commerce_app/pages/home_screen.dart';
import 'package:e_commerce_app/pages/orders.dart';
import 'package:e_commerce_app/pages/settings.dart';
import 'package:e_commerce_app/pages/shopping_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({ Key? key }) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  late String userId;
  late List<Widget>_pages;

  @override
  void initState(){
    super.initState();
    getUserID();
    initPages();
  }

  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getUserID() async{
     User? currentUser = FirebaseAuth.instance.currentUser;
     if(currentUser != null){
        userId = currentUser.uid;
     }
  }

  void initPages(){
    _pages = [
      const HomeScreen(),
      ShoppingCartPage(),
      OrdersPage(userId: userId),
      const Settings(),
    ];
  }
  


  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home), 
            label: "Shopping",
            backgroundColor: Colors.yellow[900]
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart), 
            label: 'Your Cart',
            backgroundColor: Colors.yellow[900]
          ),
          
          BottomNavigationBarItem(
            icon: const Icon(Icons.lock_clock_rounded), 
            label: 'Shopping History',
            backgroundColor: Colors.yellow[900]
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings), 
            label: 'Settings',
            backgroundColor: Colors.yellow[900]
          ),
          
        ]
      ),
    );
  }
}