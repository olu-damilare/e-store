import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Auth with ChangeNotifier {

  String? _token;
  DateTime? _expiryDate;
  String? _userId;


  Future<void> signUp(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC246tkJCH0GfGI6mDR_Coqh25RO-mG0fA';
    try {
      final response = await post(Uri.parse(url), body: json.encode(
          {
            "email": email,
            'password': password,
            'returnSecureToken': true
          }
      ));
      print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }
}