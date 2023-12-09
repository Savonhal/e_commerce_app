import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class EditShippingAddress extends StatefulWidget {
  const EditShippingAddress({ Key? key }) : super(key: key);

  @override
  _EditShippingAddressState createState() => _EditShippingAddressState();
}

class _EditShippingAddressState extends State<EditShippingAddress> {
  FirebaseAuth auth = FirebaseAuth.instance;
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
      // Update the document in 'shipping_addresses' collection
      await firestore.collection('users').doc(auth.currentUser?.uid).update({
        'name': name,
        'addressLine1': addressLine1,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
      });

      print("Shipping Address Updated");
    } catch (error) {
      print("Failed to add shipping address: $error");
      // Handle any errors here, possibly show an alert dialog or a snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: ThemeData.dark().canvasColor,
        appBar: AppBar(
            backgroundColor: ThemeData.dark().canvasColor,
            iconTheme: IconThemeData(
              color: Colors.yellow[900], //change your color here
            ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  'Enter New Shipping Address Info',
                  style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.yellow[900]
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
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.yellow[900])
                      ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}