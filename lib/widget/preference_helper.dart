import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///create shared preference
///

class PreferenceManager {
  String nameKey = "USERNAME";
  String emailKey = "EMAIL";
  String uidKey = "UID";
  String profileURLKey = "PROFILEURL";

//set userdatails
  Future setUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(nameKey, userName);
  }

  Future setUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(emailKey, userEmail);
  }

  Future setUserID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uidKey, userID);
  }

  Future setProfileURL(String profileURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(profileURLKey, profileURL);
  }

//get userdatails
  getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString(nameKey);
    print(username);
    return username.toString();
  }

  getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(uidKey);
  }

  getPofileURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileURLKey);
  }
}
