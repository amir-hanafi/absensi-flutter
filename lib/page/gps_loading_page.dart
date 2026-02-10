import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class GpsLoadingPage extends StatefulWidget {
  const GpsLoadingPage({super.key});

  @override
  State<GpsLoadingPage> createState() => _GpsLoadingPageState();
}

class _GpsLoadingPageState extends State<GpsLoadingPage> {

  @override
  void initState() {
    super.initState();
    processGps();
  }

  /// 🔄 Ambil GPS 10x → Median
  Future<void> processGps() async {
    try {
      final position = await getAccuratePosition();

      Navigator.pop(context, position);
    } catch (e) {
      Navigator.pop(context, null);
    }
  }

  /// 🔹 Sampling GPS
  Future<Position> getAccuratePosition() async {
    List<Position> samples = [];

    for (int i = 0; i < 10; i++) {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      samples.add(pos);

      await Future.delayed(const Duration(milliseconds: 500));
    }

    return calculateMedian(samples);
  }

  /// 🔹 Hitung Median
  Position calculateMedian(List<Position> samples) {
    samples.sort((a, b) => a.latitude.compareTo(b.latitude));
    double medianLat = samples[samples.length ~/ 2].latitude;

    samples.sort((a, b) => a.longitude.compareTo(b.longitude));
    double medianLng = samples[samples.length ~/ 2].longitude;

    return Position(
      latitude: medianLat,
      longitude: medianLng,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Mengecek data, mohon tunggu beberapa saat.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
