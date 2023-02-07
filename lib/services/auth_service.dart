import 'dart:convert';

import 'package:chat_real_time/global/enviroment.dart';
import 'package:chat_real_time/models/login_response.dart';
import 'package:chat_real_time/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import dio
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User? user;

  bool _autenticando = false;

  bool get autenticando => _autenticando;

  final _storage = const FlutterSecureStorage();

  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  //getters del token de forma estática
  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: "token");
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    return await storage.delete(key: "token");
  }

  Future<bool> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };
    autenticando = true;
    var resp = await http.post(Uri.parse('${Enviroment.apiUrl}/user/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
    };
    autenticando = true;
    var resp = await http.post(Uri.parse('${Enviroment.apiUrl}/user/register'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    autenticando = false;
    if (resp.statusCode == 201) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: "token");
    if (token == null) {
      return false;
    }

    final resp = await http.get(
        Uri.parse('${Enviroment.apiUrl}/user/renewToken'),
        headers: {'Content-Type': 'application/json', 'x-token': token});
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      await logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: "token", value: token);
  }

  Future logout() async {
    await _storage.delete(key: "token");
  }
}
