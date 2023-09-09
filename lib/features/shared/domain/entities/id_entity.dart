class IdEntity {
  String id;

  IdEntity(this.id);

  factory IdEntity.fromJson(Map<String, dynamic> json) => IdEntity(json['id']);
}
