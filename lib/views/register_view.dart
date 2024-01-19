import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_master/main.dart';
import 'package:task_master/views/login_view.dart';
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool circular = false;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
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
    return InkWell(
        onTap: () async {
          setState(() {
            circular = true;
          });
          final email = _email.text;
          final password = _password.text;
          try {
            final userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

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
            snackBar = SnackBar(content: Text(errorCode));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
              circular?CircularProgressIndicator()
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
    return Container(
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
    return Container(
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
