import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/widget/image_cropper.dart';
import 'package:todo_app/widget/image_selector.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImageSelectorState imageSelectorState = ImageSelectorState();
  XFile? image;
  var pickedImage;
  final imagePicker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String imageUrl = 'assets/images/profile.jpg';
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['email'] == _user?.email) {
          setState(() {
            userName = doc['name'];
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            'Profile',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, top: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 205,
                width: 205,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        //load user profile picture
                        //but first check if the user has a profile picture
                        //if not, load the default profile picture
                        //if yes, load the user's profile picture
                        child: image != null
                            ? (kIsWeb
                                ? (Image.network(image!.path))
                                : (Image.file(File(image!.path))))
                            : Image.asset(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: IconButton(
                            onPressed: () {
                              //open image selector
                              getImage();
                            },
                            icon: const Icon(Icons.camera_alt_outlined)),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text("Name: $userName"),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text("Email: ${_user?.email}"),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .5,
                    child: const Text("Task Completed: 24"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 250,
    );
    setState(() {
      pickedImage = XFile(image!.path);
      //push picked image into firestore
      _firestore.collection('users').doc(_user?.email).update({
        'image': pickedImage.toString(),
      }).then((value) {
        print('image updated');
        //display a snackbar
        Get.snackbar(
          'Success',
          'Image Updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          snackStyle: SnackStyle.FLOATING,
        );
      
      }).catchError((err) {
        //show error message on snackbar
        Get.snackbar('Error', err.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(seconds: 3));
      });
    });
    //print(" this is the path of the image " + imageFile);
  }
}
