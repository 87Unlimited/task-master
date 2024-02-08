import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_master/firebase_options.dart';

import 'package:task_master/service/authentication_repository.dart';
import 'package:task_master/views/AddTodo.dart';
import 'package:task_master/views/login_view.dart';
import 'package:task_master/views/profile_view.dart';
import 'package:task_master/views/register_view.dart';
import 'package:task_master/views/home_view.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Get.put(AuthenticationRepository());
  runApp(
    GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          '/login/': (context) => const LoginView(),
          '/register/': (context) => const RegisterView(),
          '/home/': (context) => const HomeView(),
          '/addTodo/': (context) => const AddTodoPage(),
          // '/task/': (context) => TaskView(document: document,),
          '/profile/': (context) => const ProfileView(),
          //'/editProfile/': (context) => const EditProfileView(),
        }
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                return const LoginView();
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        }
    );
  }
}