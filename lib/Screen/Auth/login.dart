
import 'package:asgn/Screen/Auth/registration.dart';
import 'package:asgn/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import '../../Theme.dart';
import '../dashboard.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var breed_type=null;
  final  emailController =  TextEditingController();
  final  nameController =  TextEditingController();
  final  petController =  TextEditingController();
  final  passwordController =  TextEditingController();
  final _auth = FirebaseAuth.instance;
  final uid1 = new FlutterSecureStorage();

  final LocalStorage name1 = new LocalStorage('localstorage_app');
  final LocalStorage petname1 = new LocalStorage('localstorage_app');
  final LocalStorage email1 = new LocalStorage('localstorage_app');
  final LocalStorage breed1 = new LocalStorage('localstorage_app');



  @override
  Widget build(BuildContext context) {

    final emailFeild = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (emailController) {
        if (!emailController.toString().contains("@")) {
          return "Please enter the valid email";
        }
        if (emailController!.isEmpty) {
          return ("Please enter the value");
        }

      },
    );

    final nameFeild = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.people_outline),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (nameController) {
        if (nameController!.isEmpty) {
          return ("Please enter the value");
        }

      },
    );

    final petFeild = TextFormField(
      autofocus: false,
      controller: petController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        petController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.pets),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Pet Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (nameController) {
        if (nameController!.isEmpty) {
          return ("Please enter the value");
        }
      },
    );

    final passwordFeild = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        // RegExp regex= new RegExp(r'^.{6,}$');
        print(value);
        if (value!.isEmpty) {
          return (" Please enter password");
        }

      },
    );

    final breeds= SizedBox(
      child: Container(
        //   width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
           border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
          child:DropdownButtonHideUnderline(
            child: DropdownButton(

              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.only(top: 0,bottom: 0,right: 16,left: 0),

                child: Padding(
                  padding: const EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 10),
                  child: Row(
                    children: [
                      Icon(Icons.pets,color: Colors.grey,),
                      Text('  Select Breed',
                        style:  GoogleFonts.lato(
                            textStyle:TextStyle(color:Colors.black)),),
                    ],
                  ),
                ),
              ),
              value: breed_type,
              items: breed
                  .map((ite) => DropdownMenuItem(
                value: ite,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0,bottom: 0,right: 13,left: 10),
                  child: Row(
                    children: [
                      Icon(Icons.pets,color: Colors.grey,),
                      Text(' '+ite,
                        style:  GoogleFonts.lato(
                            textStyle:TextStyle(color:Colors.black)),),
                    ],
                  ),
                ),
              ))
                  .toList(),
              onChanged: (items) =>

                  setState(() => breed_type = items),
            ),
          ),
        ),
      ),
    );


    final loginButton = InkWell(
      onTap:  _isLoading ? null :() async {
        if (_formKey.currentState!.validate()) {
          if(breed_type==null){
            Fluttertoast.showToast(msg: "Please select breed");
          }
          else{
             login(
              emailController.text,
              passwordController.text,
            );
            name1.setItem('name',  nameController.text);
        petname1.setItem( 'petname', petController.text);
        breed1.setItem( 'breed',  breed_type.toString());
             email1.setItem('email', emailController.text);
          }
           }
      },
      child: Container(

          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Mytheme().primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text('LOGIN',

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
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      nameFeild,
                      SizedBox(
                        height: 20,
                      ),
                      petFeild,
                      SizedBox(
                        height: 20,
                      ),
                      breeds,
                      SizedBox(
                        height: 20,
                      ),
                      emailFeild,
                      SizedBox(
                        height: 20,
                      ),

                      passwordFeild,
                      SizedBox(
                        height: 20,
                      ),

                      loginButton,
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Dont have a account?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Regis()));
                            },
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Mytheme().primary),
                            ),
                          ),
                        ],
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

  void login(String email, String password) async {
    setState(() => _isLoading = true);
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) async => {
        uid1.write(key: 'uid', value: uid.toString()),
      Fluttertoast.showToast(msg: "Login Successful"),//
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard())),
    })
        .catchError((e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: e!.message);
    });
  }


}