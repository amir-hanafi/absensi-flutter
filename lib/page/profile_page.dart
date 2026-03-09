import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String username = "";
  String role = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString("username") ?? "User";
      role = prefs.getString("role") ?? "-";
    });
  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");
    await prefs.remove("username");
    await prefs.remove("role");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 40),

            /// ICON + USERNAME (CENTER)
            Center(
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 45,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),

            /// GARIS PEMISAH
            const Divider(),

            const SizedBox(height: 20),

            /// DATA USER (KIRI)
            const Text(
              "Username",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              username,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Role",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              role,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            /// LOGOUT BUTTON
            Center(
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(180, 45),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}