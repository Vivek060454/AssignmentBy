
import 'package:asgn/Theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';

class GridComponent extends StatefulWidget {
  const GridComponent({Key? key}) : super(key: key);

  @override
  State<GridComponent> createState() => _GridComponentState();
}

class _GridComponentState extends State<GridComponent> {
  var uuid = Uuid();
  final _auth = FirebaseAuth.instance;
  get productsellStream =>
      FirebaseFirestore.instance.collection('usersell').doc(_auth.currentUser?.uid ).collection('breeds').snapshots();


  final LocalStorage name1 = new LocalStorage('localstorage_app');
  void initState() {

    CollectionReference productsell =
    FirebaseFirestore.instance.collection('Breeds');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: productsellStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          return   snapshot.data!.docs.length == 0
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: const Text(
                  'No Pic Available!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )),
          )
              :

          GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final produc = snapshot.data!.docs[index];
                return
                  InkWell(
                    onTap: (){

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        bottom: 13,
                        right: 13,
                      ),
                      child: Stack(
                        // width: 130,

                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 13),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width,
                                    height: 260,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(.08),
                                          blurRadius: 20,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.0,
                                              10.0), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                                width: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius
                                                          .circular(
                                                          30),
                                                      bottom: Radius
                                                          .zero),
                                                  child:  CachedNetworkImage(
                                                    fadeInDuration : const Duration(milliseconds: 400),
                                                    fit: BoxFit.cover,
                                                    imageUrl: produc["image"],
                                                    width: 1000,
                                                    placeholder: (context, url) => new Image.asset('assets/img_1.png',), // Your default image here

                                                  ),)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                8, 4, 8, 6),
                                            child: Center(
                                              child: Text(
                                                  produc["breed"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        color:
                                                        Mytheme().primary
                                                      // color: Color.fromRGBO(158, 63, 97, 100),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                            ),



                          ]),
                    ),
                  );



              });
        });}


}


