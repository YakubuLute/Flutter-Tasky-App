import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var imageFile;
  var imagePicker;
  var imagePath;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String imageUrl = 'assets/images/profile.jpg';
  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (imageFile == null)
                  ? Container(
                      //defualt image
                      height: 300,
                      width: MediaQuery.of(context).size.width * .53,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),

                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 250,
                        ),
                        height: 50,
                        width: 50,
                        child: Center(
                          child: IconButton(
                              icon: const Icon(Icons.camera_enhance),
                              onPressed: () {
                                ImageCropperWidget().selectImage();
                                // imageFile == null
                                //     ? print("The type is null")
                                //     : print(" Print imageFile " + imageFile);
                              }),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.5),
                        ),
                      ),
                    )
                  : Container(
                      //imagefile container
                      height: 300,
                      width: MediaQuery.of(context).size.width * .53,
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.contain,
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
    XFile image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    setState(() {
      imageFile = File(image.path);
    });
    print(" this is the path of the image " + imageFile);
  }
}
