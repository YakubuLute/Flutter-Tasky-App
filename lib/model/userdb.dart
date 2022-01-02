import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDBManager {
  //create user database on firestore
  Future getCurrentUser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    return user;
  }

  Future getUserData(String userId) async {
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userData;
  }

  Future getUserName() async {
    User? user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot? userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
  }
}
