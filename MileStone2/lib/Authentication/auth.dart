import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:project/home_screen.dart';
import 'package:project/login_screen.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
          //if user loggedin
            if(snapshot.hasData){
              return  MyScreen();
            }
            else{
              return  LoginScreen();
            }

          },
      )
    );
  }
}
