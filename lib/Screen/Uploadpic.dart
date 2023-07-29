
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';

import 'package:uuid/uuid.dart';

import '../Theme.dart';
import '../const.dart';
class Uploadpic extends StatefulWidget {
  const Uploadpic({super.key});
  @override
  UploadpicState createState() {
    return UploadpicState();
  }
}
class UploadpicState extends State<Uploadpic> {
  final _formKey = GlobalKey<FormState>();

  var breed_type=null;
  final LocalStorage name1 = new LocalStorage('localstorage_app');
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  static String? get uid => null;
  @override
  String imageName = '';
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  Future<void>addUser()async {
    UploadTask? uploadTask;
    final path='files/${imageName}';
    final file =File(imagePath!.path);
    final ref=FirebaseStorage.instance.ref().child(path);
    uploadTask =ref.putFile(file);
    final snapshot=await uploadTask;
    var url = await snapshot.ref.getDownloadURL();
    var uuid = Uuid();
    final curUuid = uuid.v1();
    CollectionReference usersell = FirebaseFirestore.instance.
    collection('usersell').doc(_auth.currentUser?.uid ).collection('breeds');
    usersell.doc(curUuid).set({
      'title':_nameController.text,
      'details':_titleController.text,
      'image':url,
      'breed':breed_type.toString(),
      'uploadedBy':await name1.getItem( "name").toString()


       }).then((valure) {
      print('Posted');

    })
        .catchError((error)=>print('failed to post:$error'));

    CollectionReference productsell = FirebaseFirestore.instance.
    collection('Breeds');
    productsell.doc(curUuid).set({ 'title':_nameController.text,
      'details':_titleController.text,
      'image':url,
      'breed':breed_type.toString(),
      'uploadedBy':await name1.getItem("name").toString()

    }).then((valure) {
      print('Posted');

      Fluttertoast.showToast(msg: 'Posted');

    })
        .catchError((error)=>print('failed to post:$error'));

    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Sellpanelupload()));
    // print('User added');
  }
//FirebaseFirestore firestoreRef =FirebaseFirestore.instance;
//FirebaseStorage storageRef =FirebaseStorage.instance;


  clearText(){
    _nameController.clear();
    _titleController.clear();
    // _imageController.clear();

  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(

        appBar: AppBar(

          title: Text('Post pic'),
          backgroundColor: Mytheme().primary

        ),

        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    imageName == ''
                        ? InkWell(
                      onTap: (){
    imagePicker();

    },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Mytheme().primary),
                                borderRadius: BorderRadius.circular(10)
                              ),
child: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Text("Click To Add Pic",style: GoogleFonts.signika(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Mytheme().primary)),),
),
                    ),
                          ),
                        ):Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:   Container(
                        height: 100,
                        width: 100,
                        child:  Image.file(File(imagePath!.path),)
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                autofocus: false,
                controller: _nameController,
                keyboardType: TextInputType.name,
                onSaved: (value) {
                  _nameController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people_outline),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Full Pet Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                validator: (nameController) {
                  if (nameController!.isEmpty) {
                      return ("Please enter the value");
                  }

                },
              ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: false,
                    maxLines: 5,
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      _titleController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.people_outline),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Enetr Details",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    validator: (_titleController) {
                      if (_titleController!.isEmpty) {
                        return ("Please enter the value");
                      }
                      if (_titleController!.length<50) {
                        return ("Please enter atleast 50 letter");
                      }
                      //  if (!RegExp("^[a-ZA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(emailController))
                      //   {
                      //     return ("please enter the valid email");
                      //   }
                      //   return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(

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
                  ),
                ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          if(breed_type==null){
                            Fluttertoast.showToast(msg: 'Please select breed');
                          }
                          else{
                          addUser();
                          Navigator.pop(context);}
                        },
                        child: Container(

                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Mytheme().primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text('Post',

                              style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 3.0),
                            ),
                          ),

                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ),
        )
    );
  }

  imagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();

      });
    }
  }

}



