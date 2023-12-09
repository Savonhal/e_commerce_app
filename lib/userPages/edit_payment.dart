import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPayment extends StatefulWidget {
  const EditPayment({ Key? key }) : super(key: key);

  @override
  _EditPaymentState createState() => _EditPaymentState();
}

class _EditPaymentState extends State<EditPayment> {

final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvv = '';

  void _updatePaymentInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        await firestore.collection('users').doc(auth.currentUser?.uid).update({
          'paymentInfo': {
            'cardNumber': cardNumber,
            'expiryDate': expiryDate,
            'cardHolderName': cardHolderName,
            'cvv': cvv,
          },
        });

        print("Payment Information Updated");
      
      } catch (error) {
        print("Failed to update payment information: $error");
        // Handle any errors here
      }
    }
  }

 @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.yellow[800], //change your color here
            ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  'Update Payment Information',
                  style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.yellow[900]
                        )
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => cardNumber = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your card number' : null,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [ExpiryDateInputFormatter()],
                  onSaved: (value) => expiryDate = value!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter expiry date';
                    }
                    // Additional validation can be added here
                    return null;
                  },
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Card Holder Name'),
                  onSaved: (value) => cardHolderName = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter card holder name' : null,
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => cvv = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter CVV' : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Process data and navigate
                        _updatePaymentInfo();
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

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    if (newText.length > 5) {
      return oldValue;
    }
    if (newText.length == 2 && oldValue.text.length == 1) {
      return TextEditingValue(
        text: '$newText/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }
    return newValue;
  }
}