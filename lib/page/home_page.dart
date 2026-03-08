import 'package:aplikasi_absen_ujikom/page/atten_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER USER
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.redAccent,
                      ),
                      SizedBox(width: 10),
                      Text("nama user"),
                    ],
                  ),
                  const Text("notifikasi"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // MENU CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              color: Colors.red[300],
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AttenPage()),
                        );
                      },
                      child: Text("absen"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(onPressed: () {}, child: Text("2")),
                  ),
                  Expanded(
                    child: ElevatedButton(onPressed: () {}, child: Text("3")),
                  ),
                  Expanded(
                    child: ElevatedButton(onPressed: () {}, child: Text("4")),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ABSEN MASUK / PULANG
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[300],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text("absen masuk"), Text("absen pulang")],
              ),
            ),

            const SizedBox(height: 20),

            // ABSENSI BULANAN
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("absensi bulanan"),
                      Text("februari 2026 ▼"),
                    ],
                  ),

                  SizedBox(height: 15),

                  Text("hadir"),
                  SizedBox(height: 8),

                  Text("izin"),
                  SizedBox(height: 8),

                  Text("sakit"),
                  SizedBox(height: 8),

                  Text("terlambat"),
                  SizedBox(height: 8),

                  Text("alpha"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
