import 'package:fit_wallet/features/categories/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';

class CategoryEntity {
  String id;
  String name;
  String hexColor;
  String icon;
  bool isDefault;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.hexColor,
    required this.icon,
    required this.createdAt,
    required this.isDefault,
    this.updatedAt,
    this.deletedAt,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) => CategoryEntity(
        id: json["id"],
        name: json["name"],
        hexColor: json["hexColor"],
        icon: json["icon"],
        isDefault: json["isDefault"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        deletedAt: json['deletedAt'] == null
            ? null
            : DateTime.parse(json['deletedAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hexColor": hexColor,
        "icon": icon,
        "createdAt": createdAt.toIso8601String(),
        "isDefault": isDefault,
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt?.toIso8601String(),
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
