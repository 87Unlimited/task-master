import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../service/profile_controller.dart';
import '../service/user_model.dart';
import 'edit_profile_view.dart';
import 'home_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F6F6),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.to(() => HomeView(), transition: Transition.leftToRight);
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
      ),
      backgroundColor: const Color(0xffF5F6F6),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
            future: profileController.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;
                  final networkImage = user.profilePicture ?? "";
                  final image =
                  networkImage.isNotEmpty
                      ? networkImage
                      : "assets/images/profile.png";

                  return Column(
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
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
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
                        title: "Logout",
                        icon: LineAwesomeIcons.alternate_sign_out,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () async {
                          final shouldLogout = await showLogOutDialog(context);
                          if (shouldLogout) {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "/login/", (_) => false
                            );
                          } else {
                            return;
                          }
                        },
                      ),
                    ],
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

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(false);
            }, child: const Text("Cancel"),),
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child: const Text("Log Out"),),
          ],
        );
      },
    ).then((value) => value ?? false);
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
      onTap: () {
        Get.to(() => const EditProfileView());
      },
      child: Container(
        height: 60,
        width: MediaQuery
            .of(context)
            .size
            .width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xFF2196F3),
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
        style: const TextStyle(
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
