import 'dart:convert';

import 'package:fit_wallet/features/categories/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static final dateFormat = DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY);
  static final dateFormatHHMM = DateFormat('HH:mm');
  static const Uuid uuidv4 = Uuid();

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static String formatYYYDDMM(DateTime time) =>
      DateFormat('EEE dd, MMM').format(time).toString();

  static String formatDDMM(DateTime time) =>
      DateFormat('MMM dd').format(time).toString();

  static String formatYYYYMMDD(DateTime time) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(time);
  }

  static String currencyFormat(double value) {
    return NumberFormat.simpleCurrency(decimalDigits: 2).format(value);
  }

  static String currencyFormatInt(int value) {
    return NumberFormat("#,###").format(value);
  }

  static String formatDateHHMM(DateTime date) => dateFormatHHMM.format(date);

  static IconData iconFromCategory(String name) {
    return categoryIcons[name.toLowerCase()] ?? Icons.attach_money_rounded;
  }

  static String capitalText(String text) {
    List<String> words = text.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords.join(' ');
  }

  static String get uuid => uuidv4.v4();

  static int get now => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  static DateTime fromUnix(int time) =>
      DateTime.fromMillisecondsSinceEpoch(time * 1000);

  static int unix(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

  static Future<dynamic> readJsonFile(String filePath) async {
    final String response = await rootBundle.loadString(filePath);
    final data = await json.decode(response);
    return data;
  }
}
