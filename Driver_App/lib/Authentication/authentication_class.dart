import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/home_screen.dart';
import 'package:driver_app/reusable/reusable_methods.dart';

import '../Test_file/GlobalVariableForTesting.dart';

class Authentication_class{
  ReusableMethods rMethods = ReusableMethods();

  Future<int> Sign_up(String emailTextEditingController
      ,String passwordTextEditingController
      ,String nameTextEditingController
      ,String phoneTextEditingController
      ,BuildContext context) async{
    final User? userFirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController,
          password: passwordTextEditingController,
        ).catchError((errorMsg){
          rMethods.displaySnakBar(errorMsg.toString(), context);
          return 0;
        })
    ).user;
    if(!context.mounted)return 0;

    if(emailTextEditingController.trim() != "test@eng.asu.edu.eg"){
      DatabaseReference DriverRef = FirebaseDatabase.instance.ref().child("Drivers").child(userFirebase!.uid);
      Map driverDataMap = {
        "name":nameTextEditingController,
        "email":emailTextEditingController,
        "phone":phoneTextEditingController,
        "id":userFirebase.uid,
        "Type":"Driver",
        "blockStatus":"no",
      };
      DriverRef.set(driverDataMap);

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (c)=>MyScreen()));
      TESTMODE =0;
      return 1;
    }
    else{
      print("saving Test Node in Database");
      DatabaseReference DriverRef = FirebaseDatabase.instance.ref().child("Drivers").child("TEST");
      Map driverDataMap = {
        "name":nameTextEditingController,
        "email":emailTextEditingController,
        "phone":phoneTextEditingController,
        "id":"TEST",
        "Type":"Driver",
        "blockStatus":"no",
      };
      DriverRef.set(driverDataMap);

      Navigator.pushReplacement(context,MaterialPageRoute(builder: (c)=>MyScreen()));
      TESTMODE =1;
      return 1;
    }





  }



  Log_in(String emailTextEditingController
      ,String passwordTextEditingController
      ,BuildContext context)async{

    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController,
          password: passwordTextEditingController,
        ).catchError((errorMsg){
          rMethods.displaySnakBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted)return;

    if(userFirebase != null){
      DatabaseReference DriverRef = await FirebaseDatabase.instance.ref().child("Drivers").child(userFirebase!.uid);

      DriverRef.once().then((snap){
        print(snap.snapshot.value);
        if(snap.snapshot.value != null){

          if((snap.snapshot.value as Map)["blockStatus"] == "no" && snap.snapshot.value.toString() != "null"){
            Navigator.pushReplacementNamed(context,'/home_screen');
          }
          else{

            FirebaseAuth.instance.signOut();
            rMethods.displaySnakBar("The Account Not Found As Driver", context);

          }

        }else{

          FirebaseAuth.instance.signOut();
          rMethods.displaySnakBar("The Account Not Found As Driver", context);


        }


      }).onError((error, stackTrace) {
        print("The Account Not Found As Driver");
        rMethods.displaySnakBar("The Account Not Found As Driver", context);
      });
    }


  }

  Sign_out() async{
    await FirebaseAuth.instance.signOut();
  }



}