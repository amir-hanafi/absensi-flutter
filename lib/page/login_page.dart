import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  String? usernameResult;
  String? errorMessage;

  // ⭐ GANTI jika emulator
  final String baseUrl = "http://192.168.1.16:8000/api";
  // emulator android:
  // final String baseUrl = "http://10.0.2.2:8000/api";

  Future<void> login() async {
    setState(() {
      errorMessage = null;
      usernameResult = null;
    });

    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "identifier": identifierController.text,
        "password": passwordController.text,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        usernameResult = data["user"]["username"];
      });
    } else {
      setState(() {
        errorMessage = data["message"] ?? "Login gagal";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Login Laravel")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: identifierController,
              decoration: const InputDecoration(
                labelText: "Identifier",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: login,
              child: const Text("LOGIN"),
            ),

            const SizedBox(height: 30),

            // ✅ hasil username
            if (usernameResult != null)
              Text(
                "Username: $usernameResult",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            // ❌ error
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}