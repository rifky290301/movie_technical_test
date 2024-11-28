import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

Logger logger = Logger("App Logger");

void initRootLogger() {
  // Memeriksa apakah aplikasi berjalan dalam mode debug
  if (kDebugMode) {
    Logger.root.level = Level.ALL; // semua pesan log akan dicatat
  } else {
    Logger.root.level = Level.OFF; // tidak ada pesan log yang dicatat
  }

  // Mengaktifkan logging hierarkis, yang memungkinkan
  // logger child untuk mewarisi level dan
  // handler dari logger parent.
  hierarchicalLoggingEnabled = true;

  // Mendaftarkan pendengar untuk merekam peristiwa log.
  // Setiap kali ada pesan log yang dicatat,
  // callback ini akan dipanggil dengan objek LogRecord
  Logger.root.onRecord.listen((record) {
    // Jika tidak dalam mode debug, keluar dari fungsi callback.
    // Ini memastikan bahwa log hanya diproses dalam mode debug.
    if (!kDebugMode) {
      return;
    }

    var start = '\x1b[90m';
    const end = '\x1b[0m';

    switch (record.level.name) {
      case 'INFO':
        start = '\x1b[92m';
        break;
      case 'WARNING':
        start = '\x1b[93m';
        break;
      case 'SEVERE':
        start = '\x1b[103m\x1b[31m';
        break;
      case 'SHOUT':
        start = '\x1b[41m\x1b[93m';
        break;
    }

    // Mencatat pesan log yang diformat dengan warna menggunakan
    // fungsi developer.log. Level log diatur
    // sesuai dengan level dari record.
    final message = '$end$start${record.message}$end';
    developer.log(
      message,
      level: record.level.value,
    );
  });
}
