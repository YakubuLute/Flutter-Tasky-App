import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/views/todo_view.dart';

class WidgetManager {  
  Widget space(double height, BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * height);
  }

  Widget divider() {
    return Divider(
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget todoDetailsWidget(
      String title, String description, String date, BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(title),
              subtitle: Text(description),
              trailing: const Icon(Icons.notifications),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Text(date),
            ),
          )
        ],
      ),
    );
  }
}
