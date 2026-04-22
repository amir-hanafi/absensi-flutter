import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:aplikasi_absen_ujikom/page/atten_page.dart';
import 'package:aplikasi_absen_ujikom/page/marketplace_page.dart';
import 'package:aplikasi_absen_ujikom/page/schedule_page.dart';
import 'package:aplikasi_absen_ujikom/page/profile_page.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int hadir = 0;
  int izin = 0;
  int sakit = 0;
  int alpha = 0;

  String jamMasuk = "-";
  String jamPulang = "-";

  final String baseUrl = "http://192.168.1.5:8000/api";

  @override
  void initState() {
    super.initState();
    fetchJamSekolah();
    fetchRekapAbsensi();
  }

  // ================= JAM SEKOLAH =================
  Future<void> fetchJamSekolah() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/jam-sekolah"),
        headers: {"Accept": "application/json"},
      );

      debugPrint("JAM SEKOLAH: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          jamMasuk = data['jam_masuk']?.toString() ?? "-";
          jamPulang = data['jam_pulang']?.toString() ?? "-";
        });
      }
    } catch (e) {
      debugPrint("Error jam sekolah: $e");
    }
  }

  // ================= REKAP ABSENSI =================
  Future<void> fetchRekapAbsensi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("$baseUrl/rekap-absensi"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("REKAP: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          hadir = int.tryParse(data['Hadir']?.toString() ?? "0") ?? 0;
          izin  = int.tryParse(data['Ijin']?.toString() ?? "0") ?? 0;
          sakit = int.tryParse(data['Sakit']?.toString() ?? "0") ?? 0;
          alpha = int.tryParse(data['Alpha']?.toString() ?? "0") ?? 0;
        });
      } else {
        debugPrint("ERROR STATUS: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error rekap: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Home"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const SizedBox(height: 20),

            /// WELCOME
            Text(
              "Welcome, ${widget.username}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),

            const SizedBox(height: 20),

            /// MENU
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 2 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              children: [
                _menuCard(
                  icon: Icons.check_circle,
                  title: "Absen",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AttenPage()),
                  ),
                ),

                _menuCard(
                  icon: Icons.person,
                  title: "Profile",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfilePage()),
                  ),
                ),

                _menuCard(
                  icon: Icons.schedule,
                  title: "Schedule",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SchedulePage()),
                  ),
                ),

                _menuCard(
                  icon: Icons.shopping_cart,
                  title: "MarketPoin",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MarketplacePage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// JAM MASUK & PULANG
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("Jam Masuk"),
                      const SizedBox(height: 5),
                      Text(
                        jamMasuk == "-" ? "Loading..." : jamMasuk,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Jam Pulang"),
                      const SizedBox(height: 5),
                      Text(
                        jamPulang == "-" ? "Loading..." : jamPulang,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ABSENSI BULANAN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("rekap absensi"),
                      Text(DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now())),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text("Hadir: $hadir"),
                  const SizedBox(height: 8),

                  Text("Izin: $izin"),
                  const SizedBox(height: 8),

                  Text("Sakit: $sakit"),
                  const SizedBox(height: 8),

                  Text("Alpha: $alpha"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blueGrey),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}