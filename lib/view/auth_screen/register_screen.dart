import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kio_chat/view/chat_page/user_home_screen.dart';

import '../../toast.dart';
import 'firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  bool isLoading=false;
  bool isVisiblePass=true;

  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();


  var authHandler = Auth();

  Future<void> signInUser( ) async {

  String email=emailController.text.trim();
  String password=passwordController.text.trim();

  showDialog(barrierDismissible: false,
      context: context, builder: (_){
        return const Dialog(elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()),
        );
      });

  try {
    authHandler.handleSignUp(email, password)
        .then(( user) async {
          Navigator.pop(context);

    log(user.toString());
          if(user.email!=null){

          //  User users = user;
            await FirebaseFirestore.instance.collection('users')
                .doc(user.email).set({
              'name': "${user.displayName}",
              "email":user.email,
              "pic":user.photoURL,
              "uid":user.uid
                }).then((onValue){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomeScreen(user: user,)));

            });

          }
    }).catchError((e){
      Navigator.pop(context);
      log(e.toString());

    toast(context, "Password should be at least 6 characters");

    });

  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);

  if (e.code == 'user-not-found') {
      toast(context, "user-not-found");
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      toast(context, "wrong-password");
      print('Wrong password provided for that user.');
    }else{
      toast(context, "something wrong");

    }
  }

  }

  @override
  Widget build(BuildContext context) {
  Size size=MediaQuery.sizeOf(context);
  return Scaffold(
  body: Center(
  child: Card(elevation: 4,
  color: Colors.blue.shade50,
  margin: EdgeInsets.symmetric(horizontal: size.width*0.1,vertical: 10),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(30)
  ),
  child: Form(
  key: _formKey,
  child: SizedBox(
  // height: size.width*1.1,
  width: size.width*0.8,
  child: Padding(
  padding: EdgeInsets.all(size.width*0.05),
  child: SingleChildScrollView(
  child: Column(mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
  //  Image.asset(Images.kidLyingLogo,height: 80.spMin,),

  // ThreeDText(
  //   text: 'Welcome Back!',
  //   textStyle: TextStyle(fontSize: 30, color: Colors.green,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),
  //   depth: 3,
  //   style: ThreeDStyle.standard,
  // ),
  const Text("Register",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 30),),
  const SizedBox(height: 20.0,),
  TextFormField(
  controller: emailController,
  validator: (value){
  if(value!.isEmpty || value.length<4 || !value.contains('@') || !value.contains('.')){
  return 'Enter valid Email';
  }
  return null;
  }, decoration: InputDecoration(
  fillColor: CupertinoColors.systemGrey6,
  hintText: "Email",
  border: OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(10)
  ),
  filled: true,
  prefixIcon: const Icon(Icons.email_rounded,)
  ),
  ), const SizedBox(height: 20.0,),
  TextFormField(
  validator: (v){
  if(v!.isEmpty || v.length<4){
  return 'Enter Password';
  }
  return null;
  },
  controller: passwordController,
  obscureText: isVisiblePass,
  keyboardType: TextInputType.visiblePassword,
  decoration: InputDecoration(
  hintText: "Password",
  fillColor: CupertinoColors.systemGrey6,
  border: OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(10)
  ),
  filled: true,
  prefixIcon: const Icon(Icons.lock),
  suffixIcon: GestureDetector(
  onTap: (){
  setState(() {
  isVisiblePass=!isVisiblePass;
  });
  },
  child: isVisiblePass ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))
  ),
  ),
  const SizedBox(height: 5.0,),

  const SizedBox(height: 5.0,),

  Card(elevation: 4,
  shadowColor: const Color(0xFF5872b4),
  child: Container(width: size.width*0.6,
  padding: const EdgeInsets.symmetric(vertical: 5),
  decoration: const BoxDecoration(
  gradient: LinearGradient(colors: [
  Color(0xff89a1ca),
  Color(0xff6179af),
  Color(0xff89a1ca),
  ])
  ),
  child: TextButton(onPressed: (){

  if(_formKey.currentState!.validate()){
  signInUser();
  }


  },
  child: const Text("Sign In",style: TextStyle(color: Colors.white),))
  ),
  )
  ],
  ),
  ),
  ),
  ),
  ),
  ),
  ),
  );
  }




}
