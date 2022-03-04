import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/auth/auth.dart';

class Auth with ChangeNotifier {

  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  final apiKey = authKey;


  bool get isAuth{
    return token != null;
  }

  String? get token{
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token as String;

    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
    return _auth(email, password, url);

  }

  Future<void> _auth(String email, String password, String url) async{
    print("auth");
    try {
      final response = await post(Uri.parse(url), body: json.encode(
          {
            "email": email,
            'password': password,
            'returnSecureToken': true
          }
      ));
      final responseData = json.decode(response.body);
      print(responseData);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
          {
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate?.toIso8601String()
          }
         );

      prefs.setString('userData', userData);
    } catch (error) {
      print('error is $error');
      throw error;
    }
  }

  String? get userId{
    return _userId;
  }

  Future<void> signIn(String email, String password) async {
    // final apiKey = dotenv.env['api_key'];
    print('API key --> $apiKey');
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';

   return _auth(email, password, url);
  }

  Future<bool?> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData').toString()) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'].toString());

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    return true;

  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    // prefs.clear();
  }


  void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }


}