import 'package:e_commerce_app/auth/login.dart';
import 'package:e_commerce_app/userPages/edit_payment.dart';
import 'package:e_commerce_app/userPages/edit_shipping_address.dart';
import 'package:e_commerce_app/userPages/personal_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void signOut() async{
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
                  fontFamily: 'avenir',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  )
              )
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PersonalInfoPage()));
                  }, 
                  child:  Row(
                    children: [
                      Icon(Icons.person, color: Colors.yellow[900]),
                      const SizedBox(width: 10),
                      const Text(
                        'Change Personal Info',
                        style: TextStyle(color: Colors.black)
                        ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
                    ],
                  )
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditPayment()));
                  }, 
                  child: Row(
                    children: [
                      Icon(Icons.payment_rounded,color: Colors.yellow[900]),
                      SizedBox(width: 10),
                      const Text(
                        'Change Payment Info',
                        style: TextStyle(color: Colors.black)
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
                    ],
                  )
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditShippingAddress()));
                  }, 
                  child:  Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.yellow[900]),
                      const SizedBox(width: 10),
                      const Text(
                        'Change Shipping Info',
                        style: TextStyle(color: Colors.black)
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
                    ],
                  )
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: (){
                    signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${auth.currentUser?.email} signed out')),
                      );
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                  }, 
                  child:  Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.yellow[900]),
                      const SizedBox(width: 10),
                      const Text(
                        'Log Out',
                        style: TextStyle(color: Colors.black)
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
                    ],
                  )
                ),
              ),

            ],
          ),
        )
      );
  }
}