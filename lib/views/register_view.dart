import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_master/service/user_model.dart';
import 'package:task_master/service/user_repository.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _fullName;
  late final TextEditingController _phone;
  final userRepo = Get.put(UserRepository());
  bool circular = false;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    _fullName = TextEditingController();
    _phone = TextEditingController();
    super.initState();
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

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 35,
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    textItem(_email, 'Email', false),
                    const SizedBox(height: 20),
                    textItem(_password, 'Password', true),
                    const SizedBox(height: 20),
                    textItem(_fullName, 'Full Name', false),
                    const SizedBox(height: 20),
                    textItem(_phone, 'Phone No.', false),
                    const SizedBox(height: 20),
                    colorButton('Register'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login/',
                          (route) => false,
                        );
                      },
                      child: const Text('Already registered? Login here!'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
            )
        )
    );
  }

  Widget colorButton(labelText) {
    final emailController = _email;
    final passwordController = _password;
    final fullNameController = _fullName;
    final phoneController = _phone;

    return InkWell(
        onTap: () async {
          setState(() {
            circular = true;
          });

          final email = emailController.text.trim();
          final password = passwordController.text.trim();
          final user = UserModel(
            email: email,
            password: password,
            fullName: fullNameController.text.trim(),
            phoneNo: phoneController.text.trim(),
            profilePicture: "",
          );

          try {
            final userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            createUser(user);
            setState(() {
              circular = false;
            });
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login/',
                  (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            late SnackBar snackBar;
            late final String errorCode;
            print(e.code);
            switch (e.code) {
              case 'weak-password':
                errorCode = 'Password too weak';
                break;
              case 'email-already-in-use':
                errorCode = 'Email already in use';
                break;
              case 'invalid-email':
                errorCode = 'Invalid email';
                break;
              default:
                errorCode = 'Unknown error';
            }
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorCode)),
            );

            setState(() {
              circular = false;
            });
          }
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 90,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
            ),
            child: Center(
              child:
              circular?const CircularProgressIndicator()
                  : Text(
                labelText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ))
    );
  }

  Widget textItem(controller, labelText, obscure) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
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

  Widget buttonItem(String imagepath, String buttonName, double size) {
    return SizedBox(
        width: MediaQuery.of(context).size.width-60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                  buttonName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17)
              )
            ],
          ),
        )
    );
  }
}
