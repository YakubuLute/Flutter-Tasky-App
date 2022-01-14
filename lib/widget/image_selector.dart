import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({Key? key}) : super(key: key);

  @override
  ImageSelectorState createState() => ImageSelectorState();
}

class ImageSelectorState extends State<ImageSelector> {
  //

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future getImage() async {
    File? file;
    XFile? xFile;
    var imagePath;

    xFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((value) {
      setState(() {
        imagePath = File(xFile!.path);
      });
      print(value);
      print("success");
      print("This is imagePath: $imagePath");
    }).catchError((error) {
      print(error);
      print("error");
    });
  }
}
