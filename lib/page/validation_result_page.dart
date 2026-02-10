import 'package:flutter/material.dart';

class ValidationResultPage extends StatelessWidget {
  final bool isValid;

  const ValidationResultPage({
    super.key,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isValid ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isValid ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 70,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              Text(
                isValid ? "berhasil !" : "gagal !",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// DESCRIPTION
              Text(
                isValid
                    ? "menghadiri jam pelajaran"
                    : "kehadiran gagal di akses",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    "kembali ke beranda",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
