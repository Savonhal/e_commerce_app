import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:e_commerce_app/auth/login.dart';

class PaymentInfoPage extends StatefulWidget {
  final String userId;
  PaymentInfoPage({required this.userId});
  @override
  _PaymentInfoPageState createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvv = '';

  void _submitPaymentInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        await firestore.collection('users').doc(widget.userId).set({
          'paymentInfo': {
            'cardNumber': cardNumber,
            'expiryDate': expiryDate,
            'cardHolderName': cardHolderName,
            'cvv': cvv,
          },
        }, SetOptions(merge: true));

        print("Payment Information Added");
        // Navigate to next page or show success message
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) =>
              false, // This condition ensures all previous routes are removed
        );
      } catch (error) {
        print("Failed to add payment information: $error");
        // Handle any errors here
      }
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
                'Enter Payment Information',
                style: TextStyle(
                        fontFamily: 'avenir',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.yellow
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
                      _submitPaymentInfo();
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
