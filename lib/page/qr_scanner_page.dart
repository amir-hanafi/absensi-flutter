import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  String? result;
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Absensi"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              onDetect: (BarcodeCapture capture) {
                if (isScanned) return;

                final List<Barcode> barcodes = capture.barcodes;

                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;

                  if (code != null) {
                    setState(() {
                      result = code;
                      isScanned = true;
                    });

                    print("Hasil scan: $code");

                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        Navigator.pop(context, code);
                      },
                    );

                    break;
                  }
                }
              },
            ),
          ),

          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                result ?? "Scan QR untuk absen",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
