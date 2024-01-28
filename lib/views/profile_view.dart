import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'edit_profile_view.dart';

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
    const String profileImage = "assets/images/profile.png";
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF5F6F6),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home/',
                (route) => false,
              );
            },
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: Color(0xff4E5058),
              size: 28,
            )),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon:
                  Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon,
                    color: Color(0xff4E5058),)),
        ],
      ),
      backgroundColor: Color(0xffF5F6F6),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                        image: AssetImage(profileImage),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue,
                      ),
                      child: const Icon(
                          LineAwesomeIcons.alternate_pencil,
                          size: 18,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Name",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text("Email@jj.com",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              editButton(),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              profileWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                endIcon: true,
                onPress: (){},
              ),
              profileWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: (){},
              ),
            ],
          ),
        ),
      ),
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
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xff064477),
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget editButton() {
    Get.testMode = true;
    return InkWell(
      onTap: (){
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   '/editProfile/',
        //       (route) => false,
        // );
        Get.to(() => const EditProfileView());
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //     builder: (builder) => EditProfileView(
        //   document: document,
        //   id: snapshot.data!.docs[index].id!,
        // ),
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF2196F3),
        ),
        child: const Center(
          child: Text(
            "Edit Profile",
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

  // Widget button() {
  //   return InkWell(
  //     onTap: () {
  //
  //     },
  //     child: Container(
  //       height: 40,
  //       width: MediaQuery
  //           .of(context)
  //           .size
  //           .width / 2,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         color: Color(0xFF2196F3),
  //       ),
  //       child: const Center(
  //         child: Text(
  //           "Upload",
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 20,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class profileWidget extends StatelessWidget {
  const profileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(icon, color: Colors.blue, size: 30,),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        )?.apply(color: textColor),
      ),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
          child: const Icon(
              LineAwesomeIcons.angle_right,
              size: 18,
              color: Colors.grey),
      ) : null,
    );
  }
}
