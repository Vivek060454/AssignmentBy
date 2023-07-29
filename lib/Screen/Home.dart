import 'package:asgn/Screen/picdetails.dart';
import 'package:asgn/Theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

import 'Map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  get productsellStream =>
      FirebaseFirestore.instance.collection('Breeds').snapshots();


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
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(top: 10,left:10,bottom: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                        boxShadow: [
                    BoxShadow(
                    color:  Colors.grey ,
                    blurRadius: 2,
                    spreadRadius: 0.0,
                    offset: Offset(
                        0.0, 2.0), // shadow direction: bottom right
                  )
              ],

            ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.menu,color: Colors.black,),
                    ),
                  ),
                ),
                // title: Center(child: Text('Pets',style: GoogleFonts.poppins(textStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 30)))),

                actions: [

                  InkWell(
                    onTap: (){
                      showPopupMenu();

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        minRadius: 13,
                        maxRadius: 16,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/Avatar_3.png',
                              image:  'https://cdn.statusqueen.com/dpimages/thumbnail/dp_images_8-1279.jpg',
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                ]
            ),

            body: SingleChildScrollView(
              child: Column(
                children: [

                  Table(
                    columnWidths: {
                      0:FlexColumnWidth(2),
                      1:FlexColumnWidth(5)
                    },
                    children: [
                      TableRow(
                          children: [
                             Align(
                                 alignment: Alignment.centerLeft,
                                 child:
                                 Container()
                                 // Image.asset('assets/AW4185658_11.gif')
                             ),
                            // Text('jhgvh'),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Welcome, '+ name1.getItem( "name").toString(),overflow: TextOverflow.ellipsis, maxLines:1,style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                )),
                              ),
                            )
                          ]
                      )
                    ],
                  ),
                  CarouselSlider(
                    items: [
InkWell(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MapCategories()));
  },
  child:   Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 13),
        child: Container(
          margin: EdgeInsets.all(6.0),
          height: 200,
          width:MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
                image: AssetImage("assets/download.jpeg"),
                fit: BoxFit.cover,
            ),
          ),
        ),
      ),
  Positioned(
      right: 1,
      child: Container(
    height: 50,
    width:MediaQuery.of(context).size.width/2,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
     color: Mytheme().primary
    ),
        child: Center(child: Text('Find vet near me',style: GoogleFonts.signika(textStyle: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 20)),)),
  ))
    ],
  ),
),
                      //1st Image of Slider


                      //2nd Image of Slider
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MapCategories()));
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: Container(
                                margin: EdgeInsets.all(6.0),
                                height: 200,
                                width:MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: AssetImage("assets/443842e79f65f2077a39f6d9d448fd1a.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 1,
                                child: Container(
                                  height: 50,
                                  width:MediaQuery.of(context).size.width/2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Mytheme().secondary
                                  ),
                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text('Check recently viewed pic',textAlign: TextAlign.center, style: GoogleFonts.signika(textStyle: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 20)),),
                                  )),
                                ))
                          ],
                        ),
                      ),

                    ],

                    //Slider Container properties
                    options: CarouselOptions(
                      height: 180.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                  snapshot.data!.docs.length == 0
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PicDetails(
                                          storedocs[index],
                                       )));
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



                      }),
                ],
              ),
            ),
          );
        });}
    showPopupMenu(){
      showMenu<int>(
        context: context,
        position: RelativeRect.fromLTRB(25.0, 105.0, 0.0, 0.0),  //position where you want to show the menu on screen
        items: [

          PopupMenuItem(
            value: 3,
            // row has two child icon and text
            child: InkWell(
              onTap: () async{


              },
              child: Row(
                children: [
                  Icon(Icons.logout,color:Mytheme().primary,),
                  SizedBox(
                    // sized box with width 10
                    width: 10,
                  ),
                  Text("Log Out",style: GoogleFonts.lato(
                      textStyle: TextStyle(color:Mytheme().primary)),)
                ],
              ),
            ),
          ),      ],
        // offset: Offset(0, 65),
        color: Colors.white,
        elevation: 0,
        shape: const TooltipShape(),

      );

    }

}
  class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
  Rect rect, {
  TextDirection? textDirection,
  }) {
  final Path path = Path();

  path.addRRect(
  _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
  );

  return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
  final Path path = Path();
  final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

  path.moveTo(0, 10);
  path.quadraticBezierTo(0, 0, 10, 0);
  path.lineTo(rrect.width - 30, 0);
  path.lineTo(rrect.width - 20, -10);
  path.lineTo(rrect.width - 10, 0);
  path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
  path.lineTo(rrect.width, rrect.height - 10);
  path.quadraticBezierTo(
  rrect.width, rrect.height, rrect.width - 10, rrect.height);
  path.lineTo(10, rrect.height);
  path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

  return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
  side: _side.scale(t),
  borderRadius: _borderRadius * t,
  );
  }

