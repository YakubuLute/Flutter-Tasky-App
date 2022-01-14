import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/views/forgot_password_view.dart';
import 'package:todo_app/views/registeration_view.dart';
import 'package:todo_app/views/todo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/widget/preference_helper.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
//controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ////firebase auth ///
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PreferenceManager preferenceManager = PreferenceManager();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //TODO: Add text fields for email and password
                        TextFormField(
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.white,
                                  ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please A Valid Email';
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.white,
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.white,
                            ),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 30),

                        ///second text field ===Password
                        TextFormField(
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.white,
                                  ),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.white,
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.white,
                            ),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        //form submit button
                        MaterialButton(
                          elevation: 3,
                          height: 45,
                          highlightElevation: 5,

                          color: Get.isDarkMode
                              ? ThemeData.dark().primaryColor
                              : const Color.fromRGBO(24, 71, 115, 1),
                          //onpressed
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                emailController.text;
                                passwordController.text;
                              });
                              //sign in with email and password
                              await _auth
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  //if nothing went wrong then do this
                                  .then((value) {
                                //TODO: Add user to shared prefs

                                preferenceManager
                                    .setUserEmail(emailController.text);
                                preferenceManager.setUserID(value.user!.uid);
                                //
                                Get.snackbar(
                                  "Congratulation ",
                                  "You've Signed in successfully",
                                  backgroundColor: Colors.teal,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 5),
                                  snackPosition: SnackPosition.BOTTOM,
                                  padding: const EdgeInsets.all(20),
                                );

                                //navigate to todo view

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const TodoView()),
                                    (route) => false);
                                //if there's an error then do this
                              }).catchError((err) {
                                Get.snackbar('Error signing in', err.message,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    padding: const EdgeInsets.all(25));
                              });
                            }
                          },

                          ///end of onPressed
                          ///
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.white,
                            ),
                          ),
                        ),
                        //end of material button
                        const SizedBox(
                          height: 20,
                        ),

                        //forgot  password
                        ///
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordView()),
                                (route) => false);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : const Color.fromRGBO(24, 71, 115, 1)),
                          ),
                        ),
                        //TODO: sign up here or register here

                        const SizedBox(
                          height: 20,
                        ),
                        //registration page
                        ////
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterationView()),
                                (route) => false);
                          },
                          child: Text(
                            "Not having an account? Register here",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : const Color.fromRGBO(24, 71, 115, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
