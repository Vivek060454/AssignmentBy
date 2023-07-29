import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Theme.dart';
import '../../model/model.dart';
import 'login.dart';
class Regis extends StatefulWidget {
  const Regis({Key? key}) : super(key: key);

  @override
  State<Regis> createState() => _RegisState();
}

class _RegisState extends State<Regis> {
  bool value = false;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final  emailEController =  TextEditingController();
   final  phoneEController =  TextEditingController();
  final  passwordEController =  TextEditingController();
  final  checkController =  TextEditingController();
  final  cpasswordEController =
  new TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailEFeild = TextFormField(
      autofocus: false,
      controller: emailEController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailEController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your email";
        }
        return null;
      },
    );

    final phoneEFeild = TextFormField(
      autofocus: false,
      controller: phoneEController,
      keyboardType: TextInputType.phone,
      onSaved: (value) {
        phoneEController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.call),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your phone number";
        }
        if (value.length > 10 || value.length < 10) {
          return "Enter your valid phone number";
        }
        return null;
      },
    );

    final passwordEFeild = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordEController,
      onSaved: (value) {
        passwordEController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your password";
        }
        return null;
      },
    );

    final cpasswordEFeild = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: cpasswordEController,
      onSaved: (value) {
        cpasswordEController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        if (cpasswordEController.text.length > 6 &&
            passwordEController.text != value) {
          return ("password not match");
        }
        return null;
      },
    );

    final signup = InkWell(
      onTap:  _isLoading ? null :() async {
        if (_formKey.currentState!.validate()) {
          register(emailEController.text, passwordEController.text);

      }},
      child: Container(

        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Mytheme().primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text('SIGNUP',

            style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 3.0),
          ),
        ),

      ),
    );
    return Scaffold(
      backgroundColor: Mytheme().primary,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(

        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
    color: Colors.white,
    ),

    child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                            const SizedBox(
                        height: 16,
                      ),
                      emailEFeild,
                      const SizedBox(
                        height: 30,
                      ),
                      phoneEFeild,
                      const SizedBox(
                        height: 30,
                      ),
                      passwordEFeild,
                      const SizedBox(
                        height: 30,
                      ),
                      cpasswordEFeild,
                      const SizedBox(
                        height: 30,
                      ),
                      signup,
                      const SizedBox(
                        height: 30,
                      ),

                      //Checkbox
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
  void register(String email, String password) async {
    setState(() => _isLoading = true);
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel(eamil: null, phone: null);
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.phone = phoneEController.text;

    await firebaseFirestore
        .collection('usersell')
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created:)");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
  }

}