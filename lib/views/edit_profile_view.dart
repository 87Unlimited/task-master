import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:task_master/service/profile_controller.dart';
import 'package:task_master/service/user_model.dart';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_master/views/profile_view.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<EditProfileView> {
  late final LocalAuthentication auth;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    auth = LocalAuthentication();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F6F6),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: Color(0xff4E5058),
              size: 28,
            )),
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: profileController.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;
                  final id = TextEditingController(text: user.id);
                  final email = TextEditingController(text: user.email);
                  final password = TextEditingController(text: user.password);
                  final fullName = TextEditingController(text: user.fullName);
                  final phoneNo = TextEditingController(text: user.phoneNo);

                  final networkImage = user.profilePicture ?? "";
                  final image =
                      networkImage.isNotEmpty ? networkImage : "assets/images/profile.png";

                  return Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: networkImage.isNotEmpty ? Image.network(
                                  networkImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      image,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ) : Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                                child: UploadImageButton(user: user),
                              //UploadImageButton(user: user),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Form(
                          child: Column(
                            children: [
                              CustomFormField(
                                initialValue: user.email,
                                labelText: "Email",
                                prefixIcon: LineAwesomeIcons.mail_bulk,
                                controller: email,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomFormField(
                                initialValue: user.fullName,
                                labelText: "Full Name",
                                prefixIcon: LineAwesomeIcons.user,
                                controller: fullName,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomFormField(
                                initialValue: user.phoneNo,
                                labelText: "Phone",
                                prefixIcon: LineAwesomeIcons.phone,
                                controller: phoneNo,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomFormField(
                                initialValue: user.password,
                                labelText: "Password",
                                prefixIcon: LineAwesomeIcons.lock,
                                controller: password,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              InkWell(
                                onTap: () async {
                                  final userData = UserModel(
                                    id: id.text.trim(),
                                    email: email.text.trim(),
                                    password: password.text.trim(),
                                    fullName: fullName.text.trim(),
                                    phoneNo: phoneNo.text.trim(),
                                    profilePicture: networkImage,
                                  );

                                  await _authenticate(userData);

                                  if (_authorized == "Authorized") {
                                    Get.snackbar(
                                      "Authentication Completed",
                                      _authorized,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                      Colors.blue.withOpacity(0.3),
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Authentication Failed",
                                      _authorized,
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.red.withOpacity(0.3),
                                      colorText: Colors.red,
                                    );
                                  }
                                },
                                child: Container(
                                  height: 56,
                                  width: MediaQuery.of(context).size.width - 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFF2196F3),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Save Edit",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Something went wrong"));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Future<UserModel?> _authenticate(user) async {
    bool authenticated = false;
    try{
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: "Authenticate to continue",
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      await profileController.updateRecord(user);
      print("authenticated : $authenticated");
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
    }

    setState(() => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }
}

class UploadImageButton extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final UserModel user;

  UploadImageButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final firebase_storage.Reference ref = _storage
        .ref()
        .child('assets/images/${DateTime.now().millisecondsSinceEpoch}');
    final firebase_storage.UploadTask uploadTask = ref.putFile(File(image.path));
    final firebase_storage.TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

    final String downloadUrl = await snapshot.ref.getDownloadURL();

    await _firestore.collection('Users').doc(user.id).update({'ProfilePicture': downloadUrl}).whenComplete((){
      Get.to(() => const ProfileView());
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _uploadImage,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue,
        ),
        child:
            const Icon(LineAwesomeIcons.camera, size: 18, color: Colors.white),
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  final String? initialValue;
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;

  const CustomFormField({
    Key? key,
    this.initialValue,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool obscure = labelText == "Password" ? true : false;

    controller.text = initialValue ?? '';
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          label: Text(labelText),
          prefixIcon: Icon(prefixIcon),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Color(0xFF2196F3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
