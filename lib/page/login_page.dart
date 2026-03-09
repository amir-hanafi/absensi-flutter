import 'dart:convert';
import 'package:aplikasi_absen_ujikom/page/home_page.dart';
import 'package:aplikasi_absen_ujikom/page/home_student_page.dart';
import 'package:aplikasi_absen_ujikom/page/home_teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  final String baseUrl = "http://192.168.1.16:8000/api";

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Accept": "application/json"},
        body: {
          "identifier": _identifierController.text,
          "password": _passwordController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String token = data["token"];
        String username = data["user"]["username"];
        String role = data["user"]["role"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setString("username", username);
        await prefs.setString("role", role);

        if (role == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(username: username),
            ),
          );
        } else if (role == "guru") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeTeacherPage(username: username),
            ),
          );
        } else if (role == "siswa") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeStudentPage(username: username),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Tidak bisa terhubung ke server")));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),

                const Text(
                  "Attendance System",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Please login to continue",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 60),

                _buildIdentifierField(),

                const SizedBox(height: 25),

                _buildPasswordField(),

                const SizedBox(height: 30),

                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentifierField() {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: TextFormField(
        controller: _identifierController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          labelText: "Username / NIS / Kode Guru",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Identifier wajib diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          labelText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password wajib diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        elevation: 2,
        fixedSize: const Size(200, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.login), SizedBox(width: 10), Text("Login")],
            ),
    );
  }
}
