import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:todo_app/views/dummy.dart';
import 'package:todo_app/views/login_view.dart';
import 'package:todo_app/views/todo_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC0EjZcy1xhyV0gko4NUy9Js6eIbrSSPG8",
        appId: "1:438490687122:web:e789eabb3053cc17b8e84b",
        messagingSenderId: "438490687122",
        projectId: "todoapp-22445"),
  );
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(239, 244, 253, 1),
        appBarTheme: const AppBarTheme(
          textTheme: TextTheme(
            headline1: TextStyle(
                color: Color.fromRGBO(84, 110, 149, 1),
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
            color: Color.fromRGBO(84, 110, 149, 1),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ), //for lightmode
      darkTheme: ThemeData(
        //for darkmode
        brightness: Brightness.dark,
      ),
      home: MyApp(),
    );
  }
}

// shared_preference
/// firebase_auth
/// core_firebase 
/// firestore
/// image_cropper 
/// 