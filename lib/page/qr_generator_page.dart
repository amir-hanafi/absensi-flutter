import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QrGeneratorPage extends StatefulWidget {
  const QrGeneratorPage({super.key});

  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage> {
  String qrData = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();

    generateToken(); // generate awal

    /// AUTO REFRESH TIAP 1 MENIT
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      generateToken();
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // stop timer saat keluar halaman
    super.dispose();
  }

  /// 🔹 GENERATE TOKEN DINAMIS 30 MENIT
  Future<void> generateToken() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.16:8000/api/generate-qr/1"),
    );

    print(response.body);
    final data = jsonDecode(response.body);

    setState(() {
      qrData = data["token"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Generator Absensi")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (qrData.isNotEmpty) QrImageView(data: qrData, size: 250),

            const SizedBox(height: 20),

            Text(qrData, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            const Text(
              "QR otomatis berubah tiap 30 menit",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
