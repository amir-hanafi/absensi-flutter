import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleStudentPage extends StatefulWidget {
  const ScheduleStudentPage({super.key});

  @override
  State<ScheduleStudentPage> createState() => _ScheduleStudentPageState();
}

class _ScheduleStudentPageState extends State<ScheduleStudentPage> {
  List jadwal = [];
  bool isLoading = true;
  //hp
  // final String baseUrl = "http://10.77.86.197:8000/api";

  //wifi
  final String baseUrl = "http://192.168.1.5:8000/api";

  @override
  void initState() {
    super.initState();
    fetchJadwal();
  }

  Future<void> fetchJadwal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("$baseUrl/jadwal-siswa"), // 🔥 ganti ini
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          jadwal = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Color getHariColor(String hari) {
    switch (hari) {
      case "Senin":
        return Colors.blue;
      case "Selasa":
        return Colors.green;
      case "Rabu":
        return Colors.orange;
      case "Kamis":
        return Colors.purple;
      case "Jumat":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Pelajaran")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jadwal.isEmpty
          ? const Center(child: Text("Tidak ada jadwal"))
          : ListView.builder(
              itemCount: jadwal.length,
              itemBuilder: (context, index) {
                final item = jadwal[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getHariColor(item['hari']),
                      child: Text(
                        item['jam_ke'].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      item['matapel']['mata_pelajaran'] ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Hari: ${item['hari']}\n"
                      "Guru: ${item['guru']['nama'] ?? '-'}\n"
                      "Kelas: ${item['kelas']['nama_kelas'] ?? '-'}\n"
                      "Jam: ${item['jam_mulai']} - ${item['jam_selesai']}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
