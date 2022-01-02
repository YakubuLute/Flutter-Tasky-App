import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:todo_app/model/database.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:todo_app/model/userdb.dart';
import 'package:todo_app/views/about_view.dart';
import 'package:todo_app/views/dummy.dart';
import 'package:todo_app/views/login_view.dart';
import 'package:todo_app/views/profile_view.dart';
import 'package:todo_app/views/settings_view.dart';
import 'package:todo_app/widget/image_cropper.dart';
import 'package:todo_app/widget/todo_widget.dart';
import 'package:todo_app/widget/widget_manager.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  TodoViewState createState() => TodoViewState();
}

class TodoViewState extends State<TodoView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  final TodoWidgetManager todoManager = TodoWidgetManager();
  final TodoDatabase todoDatabase = TodoDatabase();
  //firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  bool isDarkMode = false;
  final WidgetManager widgetManager = WidgetManager();
  bool addTask = false;
  final _formKey = GlobalKey<FormState>();

  final UserDBManager userDBManager = UserDBManager();
  final UserModel userModel = UserModel();

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
        elevation: 2,
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/profile.jpg',
            ),
          ),
        ),
        title: Text(
          'My Tasks',
          style: Theme.of(context).textTheme.headline1!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Get.isDarkMode
                  ? Colors.white
                  : const Color.fromRGBO(84, 110, 149, 1)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.segment_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor:
            Get.isDarkMode ? ThemeData.dark().primaryColor : Colors.teal,
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            //header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.transparent : Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  title: Text("Hello $userName"),
                  subtitle: Text("${_user!.email}"),
                  trailing: IconButton(
                    onPressed: () {
                      Get.isDarkMode
                          ? Get.changeThemeMode(ThemeMode.light)
                          : Get.changeThemeMode(ThemeMode.dark);
                      setState(() {
                        isDarkMode = true;
                      });
                    },
                    icon: Get.isDarkMode
                        ? const Icon(Icons.dark_mode)
                        : const Icon(Icons.light_mode),
                  ),
                  onTap: () {
                    Get.to(const ProfileView());
                  },
                ),
              ),
            ),

            //end header
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Get.to(TodoView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Get.to(SettingsView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Get.to(AboutView());
              },
            ),
            //exit
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Exit app'),
              onTap: () {
                //TODO: logout and exit
                //check to see if user is signed in
                if (_auth.currentUser != null) {
                  _auth.signOut();
                  Get.to(LoginView());
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TodoWidgetManager().todoWidget(context),
          //TODO: add a todo list
          Positioned(
            height: 50,
            right: 50,
            bottom: 80,
            child: InkWell(
              onTap: () {
                setState(() {
                  addTask = true;
                  //clear all text fields
                  titleController.text = "";
                  descriptionController.text = "";
                  dateController.text = "";
                  timeController.text = "";
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_outlined,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),

          //TODO:Get number of completed tasks
          Positioned(
            height: 60,
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    size: 30,
                    color: Get.isDarkMode
                        ? Colors.white
                        : const Color.fromRGBO(24, 71, 115, 1),
                  ),
                  title: Row(
                    children: [
                      Text(
                        'Completed',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Get.isDarkMode
                                ? Colors.white
                                : const Color.fromRGBO(24, 71, 115, 1)),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Get.isDarkMode
                            ? Colors.white
                            : const Color.fromRGBO(84, 110, 149, 1),
                      ),
                    ],
                  ),
                  trailing: Text('24'),
                ),
              ),
            ),
          ),

          //get todo
          Positioned(
            child: addTask
                ? createForm(context, titleController, descriptionController,
                    dateController, timeController)
                : Container(),
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
        ],
      ),
    );
  }

  Widget createForm(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController descriptionController,
    TextEditingController dateController,
    TextEditingController timeController,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? ThemeData.dark().backgroundColor
            : Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: TextButton.icon(
                      //when user press the done button
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            addTask = false;
                            titleController.text;
                            descriptionController.text;
                            dateController.text;
                            timeController.text;
                          });
                          //if no error
                          todoDatabase
                              .addData(
                                  titleController.text,
                                  descriptionController.text,
                                  dateController.text,
                                  timeController.text)
                              .then((value) {
                            //if is successfull
                            //display a success message
                            Get.snackbar('Success', 'Task added successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                                borderRadius: 10,
                                margin: const EdgeInsets.all(20),
                                snackStyle: SnackStyle.FLOATING);
                          }).catchError((err) {
                            //if theres an error
                            //display a error message
                            Get.snackbar(
                                'Error adding a todo', 'Task not added',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                                borderRadius: 10,
                                margin: const EdgeInsets.all(20),
                                snackStyle: SnackStyle.FLOATING);
                          });
                        } //end of validator
                      },
                      label: Text(
                        "Done",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.white,
                            ),
                      ),
                      icon: Icon(
                        Icons.done_all_outlined,
                        color: Get.isDarkMode ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: IconButton(
                      onPressed: () async {
                        titleController.clear();
                        descriptionController.clear();
                        dateController.clear();
                        timeController.clear();
                        setState(() {});
                        //TODO:Add task here to db

                        addTask = false;
                      },
                      icon: Icon(
                        Icons.close,
                        color: Get.isDarkMode ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
                    ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: 'Title',
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

              //description text form field
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
                    ),
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: 'Description',
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

              ///date text form field
              TextFormField(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now(),
                    helpText: 'Select Date',
                  ).then((value) {
                    var dateFormat =
                        DateFormat('dd-MM-yyyy').format(value!).toString();
                    setState(() {
                      dateController.text = dateFormat;
                    });
                  }).catchError(
                      (onError) => print("Select a valid date ${onError}"));
                },
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
                    ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                controller: dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Enter Date',
                  labelStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: 'MM-DD-YYYY',
                  hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              //time textform field
              TextFormField(
                onTap: () {
                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                      .then((value) {
                    var timeFormat = value!.format(context).toString();
                    print(timeFormat);
                    setState(() {
                      timeController.text = timeFormat;
                    });
                  }).catchError((onError) {
                    print("Select a valid time ${onError}");
                  });
                },
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.white,
                    ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
                controller: timeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Enter Time',
                  labelStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  hintText: '00:00',
                  hintStyle: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.white,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
