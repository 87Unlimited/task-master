import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker _picker = ImagePicker();
  late final XFile? image;

  @override
  void initState() {
    super.initState();
    image = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F6F6),
        body: SingleChildScrollView(
          // child: Container(
          //   padding: const EdgeInsets.all(100),
          //   child: FutureBuilder(
          //     builder: (context, snapshot){
          //       if(snapshot.connectionState == ConnectionState.done){
          //         return
          //       } else {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //     },
          //   ),
          // ),
          
          // child: SafeArea(
          //   child: Container(
          //     width: MediaQuery
          //         .of(context)
          //         .size
          //         .width,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         CircleAvatar(
          //           radius: 60,
          //           backgroundImage: null,
          //         ),
          //         SizedBox(
          //           height: 30,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             button(),
          //             IconButton(
          //               onPressed: () async {
          //                 image =
          //                 await _picker.pickImage(source: ImageSource.gallery);
          //                 setState(() {
          //                   image = image;
          //                 });
          //               },
          //               icon: Icon(
          //                 Icons.add_a_photo,
          //                 color: Colors.blue,
          //                 size: 30,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        )
    );
  }

  // Future<String> uploadImage(String path, XFile image) {
  //   try {
  //     final ref = Fire
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (e) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //
  //   }
  // }

  // ImageProvider getImage() {
  //   if(image != null && image?.path != null) {
  //     return FileImage(File(image?.path ?? ""));
  //   }
  //   return AssetImage("google.png");
  // }

  Widget button() {
    return InkWell(
      onTap: () {

      },
      child: Container(
        height: 40,
        width: MediaQuery
            .of(context)
            .size
            .width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF2196F3),
        ),
        child: const Center(
          child: Text(
            "Upload",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
