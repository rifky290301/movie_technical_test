import 'package:flutter/material.dart';

void showErrorDialog(
  BuildContext context, {
  required void Function() callData,
  required String message,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Dialog tidak bisa ditutup dengan menyentuh di luar
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Failure',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          // Tombol Batal
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: const Text('Cencel'),
          ),
          // Tombol Ambil Data Lagi
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              callData();
            },
            child: const Text('Try Again'),
          ),
        ],
      );
    },
  );
}
