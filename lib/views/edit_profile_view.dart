import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:task_master/service/profile_controller.dart';
import 'package:task_master/service/user_model.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<EditProfileView> {
  static const String profileImage = "assets/images/profile.png";
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _fullName;
  late TextEditingController _phone;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
    _fullName = TextEditingController();
    _phone = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _fullName.dispose();
    _phone.dispose();
    super.dispose();
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
                              const SizedBox(height: 20,),
                              CustomFormField(
                                initialValue: user.fullName,
                                labelText: "Full Name",
                                prefixIcon: LineAwesomeIcons.user,
                                controller: fullName,
                              ),
                              const SizedBox(height: 20,),
                              CustomFormField(
                                initialValue: user.phoneNo,
                                labelText: "Phone",
                                prefixIcon: LineAwesomeIcons.phone,
                                controller: phoneNo,
                              ),
                              const SizedBox(height: 20,),
                              CustomFormField(
                                initialValue: user.password,
                                labelText: "Password",
                                prefixIcon: LineAwesomeIcons.lock,
                                controller: password,
                              ),
                              const SizedBox(height: 50,),
                              InkWell(
                                onTap: () async {
                                  final userData = UserModel(
                                      id: id.text.trim(),
                                      email: email.text.trim(),
                                      password: password.text.trim(),
                                      fullName: fullName.text.trim(),
                                      phoneNo: phoneNo.text.trim()
                                  );

                                  await profileController.updateRecord(userData);
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
