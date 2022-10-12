import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Cache {

  Future<Map<String, dynamic>> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return Future.value(json.decode(prefs.getString(key) ?? "{}"));
  }

  Future<void> save(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}