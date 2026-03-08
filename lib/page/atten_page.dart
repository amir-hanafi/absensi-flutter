import 'dart:convert';
import 'package:aplikasi_absen_ujikom/page/validation_result_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_absen_ujikom/page/gps_loading_page.dart';
import 'package:aplikasi_absen_ujikom/page/qr_scanner_page.dart';
import 'package:aplikasi_absen_ujikom/page/qr_generator_page.dart';

class AttenPage extends StatefulWidget {
  const AttenPage({super.key});

  @override
  State<AttenPage> createState() => _AttenPageState();
}

class _AttenPageState extends State<AttenPage> {
  Future<void> sendAttendance({
    required String token,
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse("http://192.168.1.16:8000/api/scan-qr");

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {
        "token": token,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      },
    );

    print("TOKEN: $token");
    print("LAT: $latitude");
    print("LNG: $longitude");
    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    bool valid = data["status"] == "valid";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ValidationResultPage(isValid: valid, message: data["message"]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absen'), backgroundColor: Colors.blue),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                /// 1 scan QR
                final token = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrScannerPage()),
                );

                if (token == null) return;

                /// 2 ambil GPS
                final position = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GpsLoadingPage()),
                );

                if (position == null) return;

                double latitude = position.latitude;
                double longitude = position.longitude;

                /// 3 kirim ke Laravel
                await sendAttendance(
                  token: token,
                  latitude: latitude,
                  longitude: longitude,
                );
              },

              child: const Text("Scan QR"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrGeneratorPage()),
                );
              },
              child: const Text("Generate QR (Testing)"),
            ),
          ],
        ),
      ),
    );
  }
}
