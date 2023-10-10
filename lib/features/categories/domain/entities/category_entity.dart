import 'package:fit_wallet/features/categories/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';

class CategoryEntity {
  String id;
  String name;
  String hexColor;
  String icon;
  DateTime createdAt;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.hexColor,
    required this.icon,
    required this.createdAt,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) => CategoryEntity(
        id: json["id"],
        name: json["name"],
        hexColor: json["hexColor"],
        icon: json["icon"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hexColor": hexColor,
        "icon": icon,
        "createdAt": createdAt.toIso8601String(),
      };

  String get nameTxt {
    final firstLetter = name.substring(0, 1).toUpperCase();
    return '$firstLetter${name.substring(1).toLowerCase()}';
  }

  IconData get iconData {
    final data = categoryIcons[icon];
    if (data == null) return Icons.attach_money_rounded;
    return data;
  }

  int? get color {
    return int.tryParse('0xFF$hexColor');
  }
}
