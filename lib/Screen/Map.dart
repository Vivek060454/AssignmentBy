import 'dart:async';

import 'package:asgn/Screen/details.dart';
import 'package:asgn/Screen/widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:localstorage/localstorage.dart';


import '../Theme.dart';

class MapCategories extends StatefulWidget {
  @override
  _MapCategoriesState createState() => _MapCategoriesState();
}

class _MapCategoriesState extends State<MapCategories> {



  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor markerIcon;

  late BitmapDescriptor markerIcon1;



  var s;

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

  final LocalStorage storage1 = new LocalStorage('localstorage_app');
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  final LocalStorage stor1 = new LocalStorage('localstorage_app');
  final LocalStorage stora1 = new LocalStorage('localstorage_app');
  static final CameraPosition _kgoogleplex =
  const CameraPosition(target: LatLng(19.1955645, 72.9630627), zoom: 14);
  final storage2 = new FlutterSecureStorage();

  var se;
  double su = 0;

  get MarkerStream => FirebaseFirestore.instance
      .collection('Marker')
      .
//where('Name',arrayContainsAny:stora1.getItem('name') ).
  snapshots();

  void initState() {

    addCustomIcon();
    final _auth = FirebaseAuth.instance;
    //  print(storage1.getItem('name'));
    _getCurrentPosition();
    CollectionReference Marker =
    FirebaseFirestore.instance.collection('Marker');
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getnearbylocation() async {}

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

//
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  @override
  Widget build(BuildContext context) {
    return _currentPosition == null
        ?
    //check if loading is true or false
    Loading()
        : StreamBuilder<QuerySnapshot>(
        stream: MarkerStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
                var c;
                for (var i=0; i<storedocs.length;i++){
           var s=     Geolocator.distanceBetween( _currentPosition!.latitude,_currentPosition!.longitude,double.parse(storedocs[i]['lati']),double.parse(storedocs[i]['long']));
          var a= s/1000;
           c = a.toString().substring(0, 4);
           print(c);
                }
          // for (var i = 0; i < storedocs.length; i++) {
          //   s=storedocs[i]['Name'];
          //    var se=storedocs[i]['dataa'].length;
          //   su +=( double.parse(storedocs[i]['dataa'][i]['Rating'])/se);
          //   print('asfgsgaerfgs$su');
          // }

          List<Marker> _marker = [
            for (var i = 0; i < storedocs.length; i++) ...[
              if (storedocs[i]['Types'] == 'Vet') ...[
                Marker(
                    markerId: MarkerId(storedocs[i]['id']),
                    position: LatLng(double.parse(storedocs[i]['lati']),
                        double.parse(storedocs[i]['long'])),
                    icon:markerIcon1,
                    infoWindow: InfoWindow(
                        title: storedocs[i]['LocationName'],
                        snippet: storedocs[i]['Types'],
                        onTap: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Details(
                                        storedocs[i],
                                        _currentPosition!.latitude,
                                        _currentPosition!.longitude)));


                        }),
                    onTap: () {}),
              ],
              if (storedocs[i]['Types'] == 'Shop') ...[
                Marker(
                    markerId: MarkerId(storedocs[i]['id']),
                    position: LatLng(double.parse(storedocs[i]['lati']),
                        double.parse(storedocs[i]['long'])),
                    icon: markerIcon,
                    infoWindow: InfoWindow(
                        title: storedocs[i]['LocationName'],
                        snippet: storedocs[i]['Types'],
                        onTap: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Details(
                                        storedocs[i],
                                        _currentPosition!.latitude,
                                        _currentPosition!.longitude)));


                        }),
                    onTap: () {}),
              ],



            ]
          ];
          return snapshot.connectionState == ConnectionState.waiting ||
              _currentPosition == null
              ? //check if loading is true or false
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Check internet connection or location')
              ],
            ),
          )
              : MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                  backgroundColor: Mytheme().primary,
                  elevation: 0,

                   title: Center(child: Text('Find vet and shop near you',maxLines:1 ,overflow:TextOverflow.ellipsis,style: GoogleFonts.signika(textStyle: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 20)))),


              ),
              body: Stack(
                children: [
                  Positioned(
                    child: snapshot.connectionState ==
                        ConnectionState.waiting ||
                        _currentPosition == null
                        ? //check if loading is true or false
                    Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text(
                              'Check internet connection or location')
                        ],
                      ),
                    )
                        : GoogleMap(
                      markers: Set<Marker>.of(_marker),
                      onTap: (position) {
                        //   _customInfoWindowController.);
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController
                            .onCameraMove!();
                      },
                      mapType: MapType.normal,
                      compassEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated:
                          (GoogleMapController controller) {
                        _controller.complete(controller);
                        _customInfoWindowController
                            .googleMapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude),
                          zoom: 14),
                    ),
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 100,
                    width: 100,
                  ),



                  Align(
                      alignment: Alignment.bottomLeft,
                      child:
                      snapshot.connectionState ==
                          ConnectionState.waiting
                          ? Container(
                        // height: 100,
                        //    width: 200,
                        margin: const EdgeInsets.only(
                            left: 12, right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      )
                          : Container(
                        height: 100,
                        child: ListView.builder(
                            itemCount: 1,
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              s = storedocs[index]['LocationName'];
                              var se = storedocs[index]
                              ['dataa']
                                  .length;
                              su += (double.parse(
                                  storedocs[index]
                                  ['dataa']
                                  [index]
                                  ['Rating']) /
                                  se);
                              return Padding(
                                padding:
                                const EdgeInsets.all(
                                    8.0),
                                child: InkWell(
                                  onTap: () {
                                    if (storedocs[index]
                                    ['Name'] ==
                                        'EVCharging') {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Evdetails(
                                      //             storedocs[
                                      //             index],
                                      //             _currentPosition!
                                      //                 .latitude,
                                      //             _currentPosition!
                                      //                 .longitude)));
                                    }
                                    if (storedocs[index]
                                    ['Name'] ==
                                        'EVService') {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => EvServicedetails(
                                      //             storedocs[
                                      //             index],
                                      //             _currentPosition!
                                      //                 .latitude,
                                      //             _currentPosition!
                                      //                 .longitude)));
                                    }
                                    if (storedocs[index]
                                    ['Name'] ==
                                        'EvShowroom') {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => EvShowroomdetails(
                                      //             storedocs[
                                      //             index],
                                      //             _currentPosition!
                                      //                 .latitude,
                                      //             _currentPosition!
                                      //                 .longitude)));
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 320,
                                    margin: const EdgeInsets
                                        .only(
                                        left: 12,
                                        right: 12),
                                    decoration:
                                    BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius
                                          .circular(0),
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets
                                          .all(8.0),
                                      child: Column(
                                        children: [
                                          Align(
                                              alignment:
                                              Alignment
                                                  .topLeft,
                                              child: Text(
                                                  storedocs[
                                                  index]
                                                  [
                                                  'LocationName'],
                                                  maxLines:
                                                  1,
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                  style: GoogleFonts
                                                      .signika(
                                                    textStyle: TextStyle(
                                                        fontSize:
                                                        20,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Color.fromRGBO(
                                                            158,
                                                            63,
                                                            97,
                                                            100)),
                                                  ))),
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .all(
                                                8.0),
                                            child: Table(
                                              columnWidths: {
                                                0: FlexColumnWidth(
                                                    4),
                                                1: FlexColumnWidth(
                                                    4),
                                              },
                                              //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                                              children: [
                                                TableRow(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                        Alignment.bottomLeft,
                                                        child:
                                                        Text(
                                                          (Geolocator.distanceBetween(_currentPosition!.latitude, _currentPosition!.longitude, double.parse(storedocs[index]['lati']), double.parse(storedocs[index]['long'])) / 1000).toString().substring(0, 4) + 'km',
                                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                        Alignment.bottomRight,
                                                        child:
                                                        RatingBar.builder(
                                                          initialRating: double.parse(su.toString()),
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
                                                    ]),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                top: 0,
                                                bottom:
                                                0,
                                                left: 8,
                                                right:
                                                8),
                                            child: Table(
                                              columnWidths: {
                                                0: FlexColumnWidth(
                                                    4),
                                                1: FlexColumnWidth(
                                                    4),
                                              },
                                              //   border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                                              children: [
                                                TableRow(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                        Alignment.bottomLeft,
                                                        child:
                                                        Text(
                                                          storedocs[index]['Types'],
                                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                        Alignment.bottomRight,
                                                        child:
                                                        Text(
                                                          'Neraby',
                                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
                                                        ),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )

                  )

                ],
              ),

            ),
          );
        });
  }
}