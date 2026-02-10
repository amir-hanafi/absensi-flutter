import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  void generateToken() {
    final now = DateTime.now();

    int minute = now.minute < 30 ? 0 : 30;

    final roundedTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      minute,
    );

    final newToken =
        "ABSEN_${roundedTime.year}"
        "${roundedTime.month.toString().padLeft(2, '0')}"
        "${roundedTime.day.toString().padLeft(2, '0')}_"
        "${roundedTime.hour.toString().padLeft(2, '0')}"
        "${minute.toString().padLeft(2, '0')}";

    /// Kalau token berubah → update QR
    if (newToken != qrData) {
      setState(() {
        qrData = newToken;
      });

      print("TOKEN QR UPDATE: $qrData");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Generator Absensi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (qrData.isNotEmpty)
              QrImageView(
                data: qrData,
                size: 250,
              ),

            const SizedBox(height: 20),

            Text(
              qrData,
              style: const TextStyle(fontSize: 16),
            ),

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
