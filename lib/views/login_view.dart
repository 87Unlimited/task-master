import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:local_auth/local_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool circular = false;

  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();

    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
        _supportState = isSupported;
      }),
    );
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
                children: <Widget>[
                  if(_supportState)
                    const Text('This device support authentication')
                  else
                    const Text('This device do not support'),
                  const Text(
                      "Sign in",
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
                  colorButton('Login'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/register/',
                        (route) => false,
                      );
                    },
                    child: const Text('Not registered yet? Register here!'),
                  ),
                ],
              )
          ),
        )
    );
  }

  Widget colorButton(labelText) {
    return InkWell(
        onTap: () async {
          setState(() {
            circular = true;
          });
          // final email = _email.text;
          // final password = _password.text;
          final email = "bbb123jack@gmail.com";
          final password = "Jackjack803";

          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            setState(() {
              circular = false;
            });
            if (!context.mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home/',
                  (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            late SnackBar snackBar;
            late final String errorCode;
            print(e.code);
            switch (e.code) {
              case 'user-not-found':
                errorCode = 'User not found';
                break;
              case 'wrong-password':
                errorCode = 'Wrong password';
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
              circular?const CircularProgressIndicator()
              : Text(
                labelText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )
        )
    );
  }

  Widget textItem(controller, labelText, obscure) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
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
}
