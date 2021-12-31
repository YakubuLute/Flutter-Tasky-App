import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoDatabase {
  //push data to database
  Future<void> addData(
      String title, String description, String date, String time) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = await _auth.currentUser!;
    final String uid = user.uid;

    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('todo');
    await collectionReference.doc(uid).collection('todo').add({
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    });
  }

  final TodoModel todoModel = TodoModel();
  //get data from database
  Future getData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = await _auth.currentUser!;
    final String uid = user.uid;
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('todo');
    QuerySnapshot snapshot =
        await collectionReference.doc(uid).collection('todo').get();
    return snapshot;
  }

  ///
  Future<String> getEmail() async {
    String _email = await FirebaseAuth.instance.currentUser!.email.toString();
    var a = await FirebaseFirestore.instance
        .collection("met_with")
        .where('email', isEqualTo: _email)
        .get();
    return a.docs[0]['email'];
  }

  //delete data from database
  Future<void> deleteData(String id) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = await _auth.currentUser!;
    final String uid = user.uid;
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('todo');
    await collectionReference.doc(uid).collection('todo').doc(id).delete();
  }
}

/* 

FutureBuilder(
            future: getEmail(),
            builder: (BuildContext context, snapshot) {
            if(snapshot.hasData){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
               return Center( // here only return is missing
                  child: Text(snapshot.data['email'])
                );
              }
            }else if (snapshot.hasError){
              return Text('no data');
            }
              return CircularProgressIndicator();
            },
          ),
*/