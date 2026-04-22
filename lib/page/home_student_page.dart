import 'package:aplikasi_absen_ujikom/page/atten_student_page.dart';
import 'package:aplikasi_absen_ujikom/page/marketplace_page.dart';
import 'package:aplikasi_absen_ujikom/page/schedule_page.dart';
import 'package:aplikasi_absen_ujikom/page/schedule_student_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_absen_ujikom/page/profile_page.dart';

class HomeStudentPage extends StatelessWidget {

  final String username;

  const HomeStudentPage({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: Colors.blueGrey,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            const SizedBox(height: 20),

            /// WELCOME TEXT
            Text(
              "Welcome, $username",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),

            const SizedBox(height: 20),

            /// GRID MENU
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: isSmallScreen ? 2 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              children: [

                /// ABSEN
                _menuCard(
                  icon: Icons.check_circle,
                  title: "Absen",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AttenStudentPage(),
                      ),
                    );
                  },
                ),

                /// PROFILE
                _menuCard(
                  icon: Icons.person,
                  title: "Profile",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(),
                      ),
                    );
                  },
                ),

                

                /// MENU 4
                _menuCard(
                  icon: Icons.schedule,
                  title: "Schedule",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScheduleStudentPage()),
                    );
                  },
                ),


                // _menuCard(
                //   icon: Icons.analytics,
                //   title: "Reports",
                //   onTap: () {},
                // ),

                _menuCard(
                  icon: Icons.shopping_cart,
                  title: "MarketPoin",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketplacePage(),
                      ),
                    );
                  },
                ),

              ],
            ),

            const SizedBox(height: 30),

            /// ABSEN MASUK / PULANG
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("jam Masuk"),
                  Text("jam Pulang"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ABSENSI BULANAN
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Absensi Bulanan"),
                      Text("Februari 2026 ▼"),
                    ],
                  ),

                  SizedBox(height: 15),

                  Text("Hadir"),
                  SizedBox(height: 8),

                  Text("Izin"),
                  SizedBox(height: 8),

                  Text("Sakit"),
                  SizedBox(height: 8),

                  Text("Terlambat"),
                  SizedBox(height: 8),

                  Text("Alpha"),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {

    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(12),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 40,
              color: Colors.blueGrey,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),

          ],
        ),
      ),
    );
  }
}