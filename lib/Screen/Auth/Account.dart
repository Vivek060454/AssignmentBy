import 'package:asgn/Screen/Uploadpic.dart';
import 'package:asgn/Theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../grid_component.dart';
import 'login.dart';


class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);
  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

  var name;
  var email;

  final  name1 =  LocalStorage('localstorage_app');
  final  email1 =  LocalStorage('localstorage_app');
  final uid1 =  FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Mytheme().primary
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: 100,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: Mytheme().primary,
            shape:
            BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () async {
              SharedPreferences authdetails = await SharedPreferences.getInstance();
              FirebaseAuth.instance.signOut();
              await authdetails.remove('uid');
               await uid1.delete(key: 'uid');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            child: Text('Sign Out'),
          )
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(4)},
                children: [
                  TableRow(children: [
                    CircleAvatar(
                        backgroundColor: Color.fromRGBO(140,88,38, 100),
                        radius: 38,
                        child: Text(
                             name1.getItem( "name")
                                .toString()[0]
                                .toUpperCase(),
                            style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 38, fontWeight: FontWeight.bold),
                            ))

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(  name1.getItem( "name").toString(),
                                  style: GoogleFonts.signika(
                                    textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ))
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(   email1.getItem("email").toString(),
                                  style: GoogleFonts.signika(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ))
                          ),
                        ],
                      ),
                    )
                  ])
                ],
              ),
            ),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Uploadpic()));
                },
                child: Container(
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Mytheme().secondary,width: 3)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('Click to post Pic',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Mytheme().secondary),),
                    ))),

            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text('Your pet pic',style: GoogleFonts.lato(textStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: Mytheme().primary),)),
                )),

            GridComponent(),

          ],
        ),
      ),
    );
  }
}
