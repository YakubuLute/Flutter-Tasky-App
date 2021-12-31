import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Feed(),
    );
  }
}

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FEED'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('todo').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.connectionState == ConnectionState.waiting) &&
                  (snapshot.data == null)) {
                return const CircularProgressIndicator.adaptive();
              }

              if ((snapshot.connectionState == ConnectionState.done) &&
                  (snapshot.data == null)) {
                return const Center(child: Text("Sorry Something went wrong"));
              }

              return ListView.separated(
                separatorBuilder: (context, int index) => const SizedBox(
                  height: 15,
                ),
                padding: EdgeInsets.all(10),
                itemBuilder: (context, int index) {
                  final QueryDocumentSnapshot<Object?> documents =
                      snapshot.data!.docs[index];
                  return ListTile(
                    leading: Icon(Icons.check_circle),
                    title: Text('${documents['title']}'),
                    subtitle: Text('${documents['description']}'),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }
            return const Center(child: Text("Sorry Something went wrong"));
          }),
    );
  }
}
