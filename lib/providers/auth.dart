import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Auth with ChangeNotifier {

  String? _token;
  DateTime? _expiryDate;
  String? _userId;


  Future<void> signUp(String email, String password) async {
    final apiKey = dotenv.env['api_key'];
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
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