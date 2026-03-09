import 'package:aplikasi_absen_ujikom/page/qr_generator_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:aplikasi_absen_ujikom/page/validation_result_page.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_absen_ujikom/page/gps_loading_page.dart';
import 'package:aplikasi_absen_ujikom/page/qr_scanner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttenTeacherPage extends StatefulWidget {
  const AttenTeacherPage({super.key});

  @override
  State<AttenTeacherPage> createState() => _AttenTeacherPageState();
}

class _AttenTeacherPageState extends State<AttenTeacherPage> {
  
  

  String tanggal = "-";
  String pukul = "-";
  String jamPelajaran = "-";
  String mataPelajaran = "-";

  Future<void> getCurrentSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    print("TOKEN DARI PREFS: $token");

    final response = await http.get(
      Uri.parse("http://192.168.1.16:8000/api/jadwal-sekarang"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (data["status"] == "ada") {
      setState(() {
        tanggal = data["tanggal"] ?? "-";
        pukul = data["pukul"] ?? "-";
        jamPelajaran = data["jam_pelajaran"]?.toString() ?? "-";
        mataPelajaran = data["mata_pelajaran"] ?? "-";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
   
        backgroundColor: Colors.blueGrey,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              /// INFO CARD
              Card(
                color: Colors.red[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      _infoRow("tgl/bln/thn", tanggal),
                      const SizedBox(height: 8),

                      _infoRow("pukul", pukul),
                      const SizedBox(height: 8),

                      _infoRow("jam pelajaran", jamPelajaran),
                      const SizedBox(height: 8),

                      _infoRow("mata pelajaran", mataPelajaran),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// SCAN CARD
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Container(
                  height: 260,
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// gambar ilustrasi
                      Image.asset("assets/images/scan_qr.png", height: 160),

                      const SizedBox(height: 10),

                      const Text(
                        "Scan QR Guru untuk Absen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTON SCAN
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QrGeneratorPage(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    "Qr absen",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text("$label :", style: const TextStyle(fontWeight: FontWeight.bold)),

        Text(value),
      ],
    );
  }
}
