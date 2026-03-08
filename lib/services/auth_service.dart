import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ganti sesuai IP Laravel kamu
  static const String baseUrl = "http://192.168.1.16:8000/api";

  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {"identifier": identifier, "password": password},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": data["message"] ?? "Login gagal"};
      }
    } catch (e) {
      return {"success": false, "message": "Tidak bisa terhubung ke server"};
    }
  }

  static Future<bool> logout() async {
    final response = await http.post(Uri.parse("$baseUrl/logout"));

    return response.statusCode == 200;
  }
}
