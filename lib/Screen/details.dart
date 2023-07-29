import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Theme.dart';
import 'Recentlyview/sql.dart';


class Details extends StatefulWidget {
  final product;
  final lati;
  final long;

  const Details(this.product, this.lati, this.long, {Key? key})
      : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  final LocalStorage name1 = new LocalStorage('localstorage_app');
  final _formKey = GlobalKey<FormState>();
  var comment;
  var rating;
  var rng = Random();
  double su = 0;
  final TextEditingController _ratingController = new TextEditingController();
  final TextEditingController _commentController = new TextEditingController();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  List<Map<String, dynamic>> _journals1 = [];

  bool _isLooading1 = true;

  void dispose() {
    _ratingController.dispose();
    _commentController.dispose();
    super.dispose();
  }


  clearText() {
    _ratingController.clear();
    _commentController.clear();
  }

 
//Add Rating function
  Future<void> addRating() async {
    CollectionReference Marker =
    FirebaseFirestore.instance.collection('Marker');
    Marker.doc(widget.product['id'])
        .update({
      'dataa': FieldValue.arrayUnion([
        {
          "Rating": rating.toString(),
          'Comment': comment,
          'UserName':  await name1.getItem( "name").toString(),
          'datee': DateTime.now().toString().substring(0, 10)
        }
      ]),

    })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));
    Navigator.pop(context);

  }




 //custom marker
  void addCustomIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/download-removebg-preview.png",
    );
    markerIcon1 = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(300, 200)),
      "assets/download__1_-removebg-preview.png",
    );

  }

  @override
  void initState() {
    addCustomIcon();
    _refreshJournals1();
    _addItem1();
    super.initState();

  }



  void _refreshJournals1() async {
    final data = await SQLHelper1.getItems();
    setState(() {
      _journals1 = data;
      _isLooading1 = false;
    });
  }

  Future<void> _addItem1() async {
    await SQLHelper1.createItem(
        widget.product['LocationName'],
        widget.product['Types'],
        widget.product['lati'],
        widget.product['long'],
      );
    _refreshJournals1();
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> _marker = [
      if (widget.product['Types'] == 'Vet') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon1,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],
      if (widget.product['Types'] == 'Shop') ...[
        Marker(
          markerId: MarkerId('1'),
          icon: markerIcon,
          position: LatLng(double.parse(widget.product['lati']),
              double.parse(widget.product['long'])),
        ),
      ],

    ];
    if (widget.product['dataa'] == null) {
      su = 0.0;
    } else {
      for (var i = 0; i < widget.product['dataa'].length; i++) {
        var s = widget.product['dataa'].length;
        su += (double.parse(widget.product['dataa'][i]['Rating']) / s);
        print('asfgsgaerfgs$su');
      }
      ;
    }

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
                  widget.product['dataa'] == null
                      ? Container()
                      : Positioned(
                    bottom: 10,
                    left: 10,
                    child: RatingBar.builder(
                      initialRating:
                      double.parse(su.toString().substring(0, 1)),
                      itemPadding: EdgeInsets.all(0),
                      itemSize: 15,
                      ignoreGestures: false,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey, //New
                                  blurRadius: 5.0,
                                )
                              ],
                            ),
                            child: IconButton(
                              onPressed: () async {
                                if (widget.product['Fb'].toString() != '') {
                                  final mapDir =
                                  widget.product['Fb'].toString();
                                  if (await canLaunch(mapDir)) {
                                    launch(mapDir);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No link Found');
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 15,
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey, //New
                                  blurRadius: 5.0,
                                )
                              ],
                            ),
                            child: IconButton(
                              onPressed: () async {
                                if (widget.product['Insta'].toString() !=
                                    '') {
                                  final mapDir =
                                  widget.product['Insta'].toString();
                                  if (await canLaunch(mapDir)) {
                                    launch(mapDir);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No link Found');
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.instagram,
                                size: 15,
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey, //New
                                  blurRadius: 5.0,
                                )
                              ],
                            ),
                            child: IconButton(
                              onPressed: () async {
                                if (widget.product['web'].toString() != '') {
                                  final mapDir =
                                  widget.product['web'].toString();
                                  if (await canLaunch(mapDir)) {
                                    launch(mapDir);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No link Found');
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.earthAsia,
                                size: 15,
                              ),
                            )),
                      ],
                    ),
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
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.product['LocationName'],
                          textAlign: TextAlign.left,
                          style: GoogleFonts.signika(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(158, 63, 97, 100),
                            ),
                          )),
                    )),

                Divider(
                  height: 1,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(6),
                      1: FlexColumnWidth(4),
                    },

                     children: [
                      TableRow(children: [
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(0.8),
                            1: FlexColumnWidth(4),
                          },


                          children: [
                            TableRow(children: [
                              InkWell(
                                onTap: () async {
                                  final mapDir =
                                      "https://www.google.com/maps/dir/?api=1&destination=${widget.product['lati']},${widget.product['long']}";
                                  if (await canLaunch(mapDir)) {
                                  launch(mapDir);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.directions),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final mapDir =
                                      "https://www.google.com/maps/dir/?api=1&destination=${widget.product['lati']},${widget.product['long']}";
                                  if (await canLaunch(mapDir)) {
                                    launch(mapDir);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    (Geolocator.distanceBetween(
                                        double.parse(
                                            widget.lati.toString()),
                                        double.parse(
                                            widget.long.toString()),
                                        double.parse(
                                            widget.product['lati']),
                                        double.parse(
                                            widget.product['long'])) /
                                        1000)
                                        .toString()
                                        .substring(0, 4) +
                                        'km',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              )
                            ]),


                          ],
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(6),
                      1: FlexColumnWidth(4),
                    }, children: [
                      TableRow(children: [
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(0.8),
                            1: FlexColumnWidth(4),
                          },

                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.place),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.product['Addrese'],
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.robotoSlab(
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.call),
                              ),
                              InkWell(
                                onTap: () {
                                  FlutterPhoneDirectCaller.callNumber(
                                      widget.product['phone']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.product['phone'],
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.robotoSlab(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                              ),
                            ]),

                          ],
                        ),
                      ]),
                    ],
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      child: InkWell(
                        onTap: () async {
                          final mapDir =
                              "https://www.google.com/maps/dir/?api=1&destination=${widget.product['lati']},${widget.product['long']}";
                          if (await canLaunch(mapDir)) {
                            launch(mapDir);
                          }
                        },
                        child: GoogleMap(
                          markers: Set<Marker>.of(_marker),
                          compassEnabled: false,
                          tiltGesturesEnabled: false,
                          mapToolbarEnabled: false,
                          scrollGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          rotateGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(double.parse(widget.product['lati']),
                                  double.parse(widget.product['long'])),
                              zoom: 14),
                        ),
                      ),
                    ),
                  ),
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




                widget.product['dataa'] == null
                    ? Container()
                    : Divider(
                  height: 1,
                ),
                widget.product['dataa'] == null
                    ? Container()
                    : Form(
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
                          child: Text('Review',
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
                                              RatingBar.builder(
                                                initialRating: 1,
                                                minRating: 1,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                onRatingUpdate: (rating1) {
                                                  setState(() {
                                                    rating = rating1;
                                                  });
                                                },
                                              ),
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
                                                        addRating();
                                                        clearText();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                            "Review Added");
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    }
                                                  },
                                                  child: Text('Add Review'))
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
                                  child: Center(child: Text('Add Review',style: GoogleFonts.signika(textStyle: TextStyle(fontWeight: FontWeight.w600,color: Mytheme().primary)),)),
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
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      widget.product['dataa'][index]['Rating']),
                                  itemPadding: EdgeInsets.all(0),
                                  itemSize: 15,
                                  ignoreGestures: false,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                SizedBox(
                                  width: 50,
                                ),
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