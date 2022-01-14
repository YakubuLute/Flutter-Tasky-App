import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:get/get.dart";
import 'package:flutter/material.dart';

class BottomSheetView {
  //create a method to show the bottom sheet or hide it
 // Function showBottomSheet;
  Widget bottomSheetView() {
    final _firestore = FirebaseFirestore.instance;
    return Container(
      width: double.infinity,
      height: 70,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('todo').snapshots(),
        //builder
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final data = snapshot.requireData;
          if (snapshot.hasData && data.docs.isNotEmpty) {
            //print(snapshot.data!.docs.length);
            return Card(
              child: ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Icon(Icons.check_circle),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Task Completed",
                      style: TextStyle(
                        color: Get.isDarkMode
                            ? Colors.white
                            : Colors.blueGrey[900],
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.arrow_drop_down_circle_outlined)),
                  ],
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  //by default all tasks are uncompleted
                  //so we query firestore to see if the task is completed
                  child: Text(data.docs.length.toString()),
                ),
              ),
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
      ),
    );
  }
}
