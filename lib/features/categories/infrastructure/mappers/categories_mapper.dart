import 'package:fit_wallet/features/categories/domain/entities/entities.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';

final class CategoriesMapper {
  static CategoryEntity fromJsonDb(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json["cate_id"],
      name: json["cate_name"],
      hexColor: json["cate_hex_color"],
      icon: json["cate_icon"],
      isDefault: json["cate_is_default"] == 1,
      createdAt: Utils.fromUnix(json["cate_created_at"]),
      updatedAt: json['cate_updated_at'] == null
          ? null
          : Utils.fromUnix(json['cate_updated_at']),
      deletedAt: json['cate_deleted_at'] == null
          ? null
          : Utils.fromUnix(json['cate_deleted_at']),
    );
  }

  static Map<String, dynamic> toJsonDb(CategoryEntity entity) {
    return {
      "cate_id": entity.id,
      "cate_name": entity.name,
      "cate_hex_color": entity.hexColor,
      "cate_icon": entity.icon,
      "cate_created_at":
          entity.createdAt != null ? Utils.unix(entity.createdAt!) : null,
      "cate_is_default": (entity.isDefault == true) ? 1 : 0,
      "cate_updated_at":
          entity.updatedAt == null ? null : Utils.unix(entity.updatedAt!),
      "cate_deleted_at":
          entity.deletedAt == null ? null : Utils.unix(entity.deletedAt!),
    };
  }
}
