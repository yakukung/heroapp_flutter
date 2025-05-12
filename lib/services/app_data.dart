import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/internal_config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Appdata extends ChangeNotifier {
  String _username = '';
  int _uid = 0;
  String _email = '';
  String _errorMessage = '';
  String _profileImage = '';
  late UserProfile user;

  GetStorage gs = GetStorage();

  int get uid => _uid;
  String get username => _username;
  String get email => _email;
  String get profileImage => _profileImage;

  set uid(int value) {
    _uid = value;
    notifyListeners();
  }

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  void setProfileImage(String url) {
    _profileImage = url;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  Future<void> fetchUserData() async {
    GetStorage gs = GetStorage();
    uid = gs.read('uid');
    final response = await http.get(Uri.parse('$API_ENDPOINT/users/$uid'));

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      _username = userData['username'] ?? '';
      _uid = int.tryParse(userData['uid'].toString()) ?? 0;
      _email = userData['email'] ?? '';
      _profileImage = userData['profile_image'] ?? '';
      _errorMessage = '';
      notifyListeners();
    } else {
      _errorMessage = 'ไม่สามารถดึงข้อมูลผู้ใช้ได้: ${response.statusCode}';
      notifyListeners();
    }
  }
}

class UserProfile {
  int uid = 0;
}
