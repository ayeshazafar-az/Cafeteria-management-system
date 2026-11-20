import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String ordersKey = 'campus_cafeteria_orders_v1';
  static const String lastTokenKey = 'campus_cafeteria_last_token_v1';
  static const String cartItemsKey = 'campus_cafeteria_cart_items_v1';
  static const String stallSettingsKey = 'campus_cafeteria_stall_settings_v1';

  static SharedPreferences? _prefs;

  /// Call once during app startup in main()
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveJsonList(
    String key,
    List> list,
  ) async {
    final prefs = await _instance;
    await prefs.setString(key, jsonEncode(list));
  }

  static Future<List>?> loadJsonList(String key) async {
    final prefs = await _instance;
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> saveJsonMap(
    String key,
    Map<String, dynamic> map,
  ) async {
    final prefs = await _instance;
    await prefs.setString(key, jsonEncode(map));
  }

  static Future?> loadJsonMap(String key) async {
    final prefs = await _instance;
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;

    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  static Future<void> saveInt(String key, int value) async {
    final prefs = await _instance;
    await prefs.setInt(key, value);
  }

  static Future<int?> loadInt(String key) async {
    final prefs = await _instance;
    return prefs.getInt(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }
}