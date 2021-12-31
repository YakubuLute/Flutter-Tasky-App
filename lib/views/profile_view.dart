import 'package:flutter/material.dart';
import 'package:todo_app/widget/image_cropper.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
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
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width * .75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 200,
                  ),
                  height: 50,
                  width: 50,
                  child: Center(
                    child: IconButton(
                        icon: const Icon(Icons.camera_enhance),
                        onPressed: () {
                          ImageCropperWidget().selectImage();
                        }),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .7,
                    child: const Text("Name: John Doe"),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .7,
                    child: const Text("Email: abc@example.com"),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * .7,
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
}
