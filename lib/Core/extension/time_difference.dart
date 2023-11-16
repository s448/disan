import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeManager {
  final dateF = DateFormat('yyyy-MM-dd');
  final timeF = DateFormat('hh:mm');
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  getTimeDifference(Timestamp startTimestamp, int d) {
    initializeDateFormatting();
    final DateTime customTimestamp =
        formatter.parse(startTimestamp.toDate().toString());
    final DateTime targetDate = customTimestamp.add(Duration(days: d));
    final Duration difference = targetDate.difference(DateTime.now());
    final int days = difference.inDays;
    final int hours = difference.inHours.remainder(24);
    return "$days : $hours";
  }

  getDateTime(Timestamp date) {
    return formatter.format(date.toDate());
  }

  getDate(Timestamp date) {
    return dateF.format(date.toDate());
  }

  getTime(Timestamp date) {
    return timeF.format(date.toDate());
  }
}
