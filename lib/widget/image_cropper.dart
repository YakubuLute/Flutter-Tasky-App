import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageCropperManager extends StatefulWidget {
  const ImageCropperManager({Key? key}) : super(key: key);

  ImageCropperWidget createState() => ImageCropperWidget();
}

class ImageCropperWidget extends State<ImageCropperManager> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  final ImagePicker imagePicker = ImagePicker();

  File? imageFile;
  String? imagePath;
  Future selectImage({ImageSource imageSource = ImageSource.gallery}) async {
  
  XFile? selectedFile = await imagePicker.pickImage(source: imageSource);

    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: selectedFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Select Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      imagePath = croppedFile!.path;
    });
    print("the path of our image is ${imagePath! + " or" + selectedFile.path}");
  }

  
}

