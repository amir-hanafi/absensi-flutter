import 'package:aplikasi_absen_ujikom/page/qr_scanner_page.dart';
import 'package:flutter/material.dart';

class AttenPage extends StatelessWidget {
  const AttenPage({super.key});

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
                }
              },
              child: const Text("Scan QR"),
            ),
          ],
        ),
      ),
    );
  }
}
