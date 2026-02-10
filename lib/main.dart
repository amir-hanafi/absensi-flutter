import 'package:aplikasi_absen_ujikom/page/atten_page.dart';
import 'package:aplikasi_absen_ujikom/page/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(), // pindah ke halaman lain
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  Widget _buildNavItem({
  required IconData icon,
  required String label,
  required int index,
}) {
  final bool isActive = _selectedIndex == index;

  return Expanded(
    child: InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? Colors.green : Colors.grey,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.green : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}


  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      AttenPage(),
    ];

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: _pages[_selectedIndex],

  bottomNavigationBar: BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 6,
    child: SizedBox(
      height: 55, // lebih pendek dari default
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: "Beranda",
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.list,
            label: "absen",
            index: 1,
          ),
        ],
      ),
    ),
  ),
);


  }
}

