import 'package:attendence/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signout extends StatefulWidget {
  const signout({super.key});

  @override
  State<signout> createState() => _signoutState();
}

class _signoutState extends State<signout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Center(child: Text("succesuful login")),
          ElevatedButton(onPressed: _signOut, child: Text("Logout"))
        ],
      ),
    );
  }
}

void _signOut() {
  FirebaseAuth.instance.signOut();

  runApp(new MaterialApp(
    home: new LoginScreen(),
  ));
}