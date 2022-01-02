import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/views/login_view.dart';
import 'package:todo_app/widget/preference_helper.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({Key? key}) : super(key: key);

  TodoWidgetManager createState() => TodoWidgetManager();
}

class TodoWidgetManager extends State<TodoWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TodoModel todoModel = TodoModel();
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget todoWidget(BuildContext context) {
    Stream<QuerySnapshot> _userData = _firestore.collection('todo').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _userData,
      //builder
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final data = snapshot.requireData;
        if (snapshot.hasData) {
          print(snapshot.data!.docs.length);
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Icon(Icons.check_circle),
                  ),
                  title: Text(data.docs[index]['title']),
                  subtitle: Text(data.docs[index]['description']),
                  trailing: Text(data.docs[index]['date'] +
                      ' ' +
                      data.docs[index]['time']),
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error getting todo's"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
