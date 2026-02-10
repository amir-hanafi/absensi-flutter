import 'package:aplikasi_absen_ujikom/page/qr_generator_page.dart';
import 'package:aplikasi_absen_ujikom/page/qr_scanner_page.dart';
import 'package:aplikasi_absen_ujikom/page/validation_result_page.dart';
import 'package:flutter/material.dart';

class AttenPage extends StatefulWidget {
  const AttenPage({super.key});

  @override
  State<AttenPage> createState() => _AttenPageState();
}

class _AttenPageState extends State<AttenPage> {
  bool validateToken(String token) {
    try {
      final parts = token.split("_");
      if (parts.length != 3) return false;

      final datePart = parts[1];
      final timePart = parts[2];

      final tokenTime = DateTime(
        int.parse(datePart.substring(0, 4)),
        int.parse(datePart.substring(4, 6)),
        int.parse(datePart.substring(6, 8)),
        int.parse(timePart.substring(0, 2)),
        int.parse(timePart.substring(2, 4)),
      );

      final now = DateTime.now();

      final diff = now.difference(tokenTime).inMinutes.abs();

      return diff <= 30; // berlaku 30 menit
    } catch (e) {
      return false;
    }
  }


  void handleScanResult(String token) {
    final isValid = validateToken(token);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ValidationResultPage(isValid: isValid),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('absen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Test'),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QrScannerPage(),
                  ),
                );

                if (result != null) {
                  print("QR diterima di AttenPage: $result");

                  handleScanResult(result); // 🔥 PANGGIL VALIDASI
                }

              },
              child: const Text("Scan QR"),
            ),
            ElevatedButton(
            child: const Text("Buka Generator QR"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QrGeneratorPage(),
                ),
              );
            },
          ),


          ],
        ),
      ),
    );
  }
}
