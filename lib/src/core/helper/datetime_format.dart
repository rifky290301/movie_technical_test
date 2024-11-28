import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Contoh : 25 Oktober 2009
  String get humans => DateFormat('dd MMMM yyyy').format(this);

  /// Contoh : 25/10/2009
  String get slash => DateFormat('dd/MM/yyyy').format(this);

  /// Contoh : 25-10-2001
  String get dash => DateFormat('dd-MM-yyyy').format(this);

  /// Contoh : Sel, 22 Januari 2019
  String get edm4y => DateFormat('EEE, dd MMMM yyyy').format(this);

  /// Contoh : Sel 22 Jan, 2019
  String get em3dy => DateFormat('EEE MMM dd, yyyy').format(this);

  /// Contoh : Selasa, 22 Januari 2019
  String get edm5y => DateFormat('EEEE, d MMM yyyy').format(this);

  /// Contoh : Selasa, 22 Januari 2019 16:48
  String get edm6y => DateFormat('EEEE, d MMMM yyyy H:mm').format(this);

  /// Contoh : Selasa
  String get daysNamePerWeek => DateFormat('EEEE').format(this);

  /// Contoh : 11:09
  String get time => DateFormat('H:mm').format(this);
}
