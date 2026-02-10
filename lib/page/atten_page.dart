import 'package:aplikasi_absen_ujikom/page/qr_generator_page.dart';
import 'package:aplikasi_absen_ujikom/page/qr_scanner_page.dart';
import 'package:aplikasi_absen_ujikom/page/validation_result_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class AttenPage extends StatefulWidget {
  const AttenPage({super.key});

  @override
  State<AttenPage> createState() => _AttenPageState();
}

class _AttenPageState extends State<AttenPage> {
  double schoolLat = -6.825286932039216;
  double schoolLng = 107.13709238539803;
  double allowedRadius = 100; // meter

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

  bool validateLocation(Position position) {
    double distance = Geolocator.distanceBetween(
      schoolLat,
      schoolLng,
      position.latitude,
      position.longitude,
    );

    print("Jarak dari sekolah: $distance meter");

    return distance <= allowedRadius;
  }


  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// Cek GPS aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("GPS tidak aktif");
    }

    /// Cek permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permission ditolak permanen");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }


  void handleScanResult(String token) async {
    final tokenValid = validateToken(token);

    bool locationValid = false;

    try {
      final position = await getCurrentLocation();
      locationValid = validateLocation(position);
    } catch (e) {
      print("Error lokasi: $e");
    }

    final finalValid = tokenValid && locationValid;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ValidationResultPage(
          isValid: finalValid),
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
