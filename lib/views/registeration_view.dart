import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/views/login_view.dart';

class RegisterationView extends StatefulWidget {
  const RegisterationView({Key? key}) : super(key: key);

  @override
  _RegisterationViewState createState() => _RegisterationViewState();
}

class _RegisterationViewState extends State<RegisterationView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  //formkey
  final _formKey = GlobalKey<FormState>();

  //initialize firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Registeration Page',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO: Add text fields for email and password
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
                    ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
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
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
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
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
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
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              // confirm password textfield
              const SizedBox(height: 30),
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
                    ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return '''Passowrd lenght should be more than 6 characters''';
                  } else if (value != passwordController.text) {
                    return "Password do not match";
                  }
                  return null;
                },
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
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
                    await _auth
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        //if nothing went wrong then do this
                        .then((value) {
                      ///push userdetails to cloud firestore
                      ///
                      _firestore.collection('users').doc(value.user!.uid).set({
                        'name': userNameController.text,
                        'email': emailController.text,
                      });
                      Get.snackbar(
                        "Account created successfully",
                        value.toString(),
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      //navigate to todo view

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginView()),
                          (route) => false);
                      //if there's an error then do this
                    }).catchError((err) {
                      Get.snackbar(
                        'Error signing in',
                        err.message,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    });
                  }
                },

                ///end of onPressed
                ///
                child: Text(
                  "Register An Account",
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                ),
              ),
              //end of material button
              const SizedBox(
                height: 20,
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
                          builder: (context) => const LoginView()),
                      (route) => false);
                },
                child: Text(
                  "Already having an account? Login here",
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
      ),
    );
  }
}
