import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_info.dart';

class ShippingAddressPage extends StatefulWidget {
  final String userId;

  ShippingAddressPage({required this.userId});

  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String addressLine1 = '';
  String state = '';
  String city = '';
  String postalCode = '';
  String country = '';

  Future<void> _storeShippingAddress() async {
    // Create an instance of Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Create a new document in 'shipping_addresses' collection
      await firestore.collection('users').doc(widget.userId).set({
        'name': name,
        'addressLine1': addressLine1,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
      });

      print("Shipping Address Added");
      // Navigate to PaymentInfoPage after successful addition
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentInfoPage(userId: widget.userId)));
    } catch (error) {
      print("Failed to add shipping address: $error");
      // Handle any errors here, possibly show an alert dialog or a snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData.dark().canvasColor,
      appBar: AppBar(
          backgroundColor: ThemeData.dark().canvasColor,
          iconTheme: const IconThemeData(
            color: Colors.yellow, //change your color here
          ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text(
                'Enter Shipping Address',
                style: TextStyle(
                        fontFamily: 'avenir',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.yellow
                      )
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                onSaved: (value) => addressLine1 = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your address' : null,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (value) => city = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your city' : null,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'State'),
                onSaved: (value) => state =
                    value!, // Assuming you have a state variable defined
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your state' : null,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Postal Code'),
                onSaved: (value) => postalCode = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your postal code' : null,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Country'),
                onSaved: (value) => country = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your country' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Process data and navigate
                      _storeShippingAddress();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
