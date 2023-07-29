import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Theme.dart';


class PicDetails extends StatefulWidget {
  final product;



  const PicDetails(this.product,  {Key? key})
      : super(key: key);

  @override
  State<PicDetails> createState() => _PicDetailsState();
}

class _PicDetailsState extends State<PicDetails> {
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  final _formKey = GlobalKey<FormState>();
  var comment;
  var rating;
  final TextEditingController _ratingController = new TextEditingController();
  final TextEditingController _commentController = new TextEditingController();



  final LocalStorage name1 = new LocalStorage('localstorage_app');
  double su = 0;

  Future<void> addUser() async {
    CollectionReference Marker =
    FirebaseFirestore.instance.collection('Breeds');
    Marker.doc(widget.product['id'])
        .update({
      'dataa': FieldValue.arrayUnion([
        {
          'Comment': comment,
          'UserName':     name1.getItem( "name").toString(),
          'datee': DateTime.now().toString().substring(0, 10)
        }
      ]),
      // {
      //   "Ratiang": FieldValue.arrayUnion([rating,comment]),
      //   'Commaent':FieldValue.arrayUnion([comment]),
      //   // 'UseraName':FieldValue.arrayUnion(['afgs']),
      //   // 'daaste':FieldValue.arrayUnion([DateTime.now()]),
      // }
    })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));
    Navigator.pop(context);
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Draweer() ));
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Sellpanelupload()));
    // print('User added');
  }




  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon2 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon3 = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon4 = BitmapDescriptor.defaultMarker;

  void addCustomIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/a.png",
    );
    markerIcon1 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker1.png",
    );
    markerIcon2 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker2.png",
    );
    markerIcon3 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker3.png",
    );
    markerIcon4 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/Marker4.png",
    );
  }

  @override
  void initState() {
    addCustomIcon();

    super.initState();
    // Loading the diary when the app starts
  }


  clearText() {
    _ratingController.clear();
    _commentController.clear();
  }

  var rng = Random();
  @override
  Widget build(BuildContext context) {
    List<Marker> _marker = [
      if (widget.product['Types'] == 'Vet') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: BitmapDescriptor.defaultMarker,
          // markerIcon4,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],
      if (widget.product['Types'] == 'Shop') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon1,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],

    ];


    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                widget.product['image'] == null
                    ? Container(
                  height: 200,
                  width: 300,
                )
                    : Stack(children: [
                  Image.network(widget.product['image'],
                      height: 230, width: 360, fit: BoxFit.fill),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(

                      child: Text("~"+widget.product['uploadedBy'],style: GoogleFonts.signika(textStyle: TextStyle(fontWeight: FontWeight.w400, color: Mytheme().primary,fontSize: 20)),),
                    )
                  ),
                  Positioned(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 40, left: 8, right: 8, bottom: 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, //New
                                blurRadius: 15.0,
                              )
                            ],
                          ),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              )),
                        ),
                      ))
                ]),

                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.product['title'],
                          textAlign: TextAlign.left,
                          style: GoogleFonts.signika(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(158, 63, 97, 100),
                            ),
                          )),
                    )),

Table(
  children: [
    TableRow(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Breeds:",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.signika(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  )),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product['breed'],

                  style: GoogleFonts.signika(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  )),
            )),

      ]
    )
  ],
),




                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product['details'],
                    textAlign: TextAlign.left,
                    style: GoogleFonts.robotoSlab(
                      textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                ),



                 Form(
                  key: _formKey,
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(6),
                      1: FlexColumnWidth(4),
                    },
                    //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Comment',
                              style: GoogleFonts.signika(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        InkWell(
                            onTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        content: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: Column(
                                            children: [

                                              TextFormField(
                                                controller:
                                                _commentController,
                                                textInputAction:
                                                TextInputAction.next,
                                                keyboardType: TextInputType
                                                    .streetAddress,
                                                decoration: InputDecoration(
                                                  fillColor:
                                                  Colors.grey.shade100,
                                                  filled: true,
                                                  hintText: 'Comment',
                                                  labelText: 'Comment*',
                                                  hintStyle: const TextStyle(
                                                      height: 2,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(0)),
                                                ),
                                                // The validator receives the text that the user has entered.
                                              ),

                                              ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        comment =
                                                            _commentController
                                                                .text;
                                                        //   rating=   _ratingController.text;
                                                        // _uploadImage();
                                                        addUser();
                                                        clearText();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            "Review Comment");
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    }
                                                  },
                                                  child: Text('Add Comment'))
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Mytheme().primary,width: 3)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(child: Text('Add Comment',style: GoogleFonts.signika(textStyle: TextStyle(fontWeight: FontWeight.w600,color: Mytheme().primary)),)),
                                ) ,
                              ),
                            )),
                      ]),
                    ],
                  ),
                ),
                widget.product['dataa'] == null
                    ? Container()
                    : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.product['dataa'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 19,
                          child: Text(
                            (widget.product['dataa'][index]['UserName'])
                                .toString()
                                .substring(0, 1),
                          ),
                        ),
                        title: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  (widget.product['dataa'][index]['UserName'])
                                      .toString(),
                                  style: GoogleFonts.signika(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                            Row(
                              children: [

                                Text(
                                    (widget.product['dataa'][index]['datee'])
                                        .toString(),
                                    style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                (widget.product['dataa'][index]['Comment'])
                                    .toString(),
                                style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                ))),
                      );
                    }),







              ],
            ),
          ),
        ));
  }
}