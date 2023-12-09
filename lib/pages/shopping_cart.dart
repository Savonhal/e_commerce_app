import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/pages/checkout.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:e_commerce_app/models/Products.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Product> cartProducts = []; // This will hold the cart items.
  String? userId;
  final CollectionReference cartCollection = FirebaseFirestore.instance.collection('carts');

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
      });
    }
  }

  Future<void> addToCart(Product product) async {
    // Get the current user from Firebase Authentication
    firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser != null) {
      String userId = currentUser.uid; // Get the user's unique ID

      // Add product to Firestore under the user's cart
      return cartCollection
          .doc(userId)
          .collection('cartItems')
          .doc(product.id.toString()) // Assuming Product has an ID
          .set(product.toJson()); // Assuming Product has a toJson method
    } else {
      // Handle the case where there is no logged in user
      throw Exception('No user logged in');
    }
  }

  Future<void> removeFromCart(Product product) async {
    firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser != null) {
      String userId = currentUser.uid;
      // Remove product from Firestore
      return cartCollection
          .doc(userId)
          .collection('cartItems')
          .doc(product.id.toString())
          .delete();
    } else {
      // Handle the case where there is no logged in user
      throw Exception('No user logged in');
    }
  }

  void updateQuantity(Product product, int newQuantity) async {
    if (newQuantity < 1) return; // Ensure the quantity is always positive.

    // Assuming your Product model has a 'quantity' field
    product.quantity = newQuantity;

    // Update the quantity in Firebase
    firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null && product.id != null) {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(currentUser.uid)
          .collection('cartItems')
          .doc(product.id.toString())
          .update({'quantity': newQuantity});
    }
  }

  Stream<List<Product>> fetchCartItems() {
    firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;

    // Check if there's a logged-in user
    if (currentUser != null) {
      String userId = currentUser.uid; // Replace with actual user ID

      // Fetch products from Firestore
      return cartCollection.doc(userId).collection('cartItems').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList());
    } else {
      // If no user is logged in, return an empty stream or handle appropriately
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
           style: TextStyle(
              fontFamily: 'avenir',
              fontSize: 32,
              fontWeight: FontWeight.w900
            )
          ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Product> cartProducts = snapshot.data!;
            return ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                var product = cartProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShoppingCartItem(
                    product: product,
                    itemName: product.title,
                    itemPrice: product.price.toDouble(),
                    quantity:
                        1, // This quantity should be managed as part of the cart logic
                    imageUrl: product.thumbnail,
                    onQuantityChanged: (newQuantity) {
                  
                      updateQuantity(product, newQuantity);
                    },
                    onRemove: () {
                  
                      removeFromCart(product);
                    },
                    cartCollection: cartCollection,
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Your cart is empty.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the checkout page
          if (userId != null) {
            // Navigate to the checkout page with the current user's ID
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CheckoutPage(userId: userId!)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No user logged in')),
            );
          }
        },
        backgroundColor: Colors.yellow[900],
        child: Icon(Icons.shopping_cart_checkout, color: Colors.white),
        tooltip: 'Go to Checkout',
      ),
    );
  }
}


class ShoppingCartItem extends StatefulWidget {
  final Product product;
  final String itemName;
  final double itemPrice; // Changed to double to calculate the total price
  final String imageUrl;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  final CollectionReference cartCollection;

  const ShoppingCartItem({
    Key? key,
    required this.product,
    required this.itemName,
    required this.itemPrice,
    required this.imageUrl,
    required this.onQuantityChanged,
    required this.onRemove,
    required int quantity,
    required this.cartCollection,
  }) : super(key: key);

  @override
  _ShoppingCartItemState createState() => _ShoppingCartItemState();
}

class _ShoppingCartItemState extends State<ShoppingCartItem> {
  int quantity = 1;

  Future<void> removeFromCart(Product product) async {
    firebase_auth.User? currentUser =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    String userId = currentUser.uid;

    try {
      await widget.cartCollection
          .doc(userId)
          .collection('cartItems')
          .doc(product.id.toString())
          .delete();

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.title} removed from cart')),
      );
    } catch (error) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove the item from the cart')),
      );
    }
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
      widget.onQuantityChanged(quantity);
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onQuantityChanged(quantity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = quantity * widget.itemPrice;

    return Card(
      margin: EdgeInsets.all(2.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          leading: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4)
                  ),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            widget.itemName,
            style: const TextStyle(
              fontFamily: 'avenir',
              fontSize: 16,
            )
            ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Quantity:',
                style: TextStyle(
                      fontFamily: 'avenir',
                      fontSize: 14,
                    )
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: _decrementQuantity,
                  ),
                  Text('$quantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 14,
                          fontWeight: FontWeight.w900)
                    ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Remove:'),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Call the method to remove the item from the cart
                      removeFromCart(widget.product);
                    },
                  ),
                ],
              ),
            ],
          ),

          trailing: Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'avenir',
              fontSize: 16,
              fontWeight: FontWeight.w900
            )
          ), // Total price
          isThreeLine: true,
          dense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          onTap: () {},
        ),
      ),
    );
  }
}
