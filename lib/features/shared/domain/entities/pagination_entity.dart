class PaginationEntity<T> {
  List<T> items;
  int page;
  int nextPage;
  int totalPages;
  int totalItems;
  int total;

  PaginationEntity({
    required this.items,
    required this.page,
    required this.nextPage,
    required this.totalPages,
    required this.totalItems,
    required this.total,
  });

  factory PaginationEntity.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> d) fromJson,
  ) =>
      PaginationEntity(
        items: (json['items'] as List).isNotEmpty
            ? (json['items'] as List).map((e) => fromJson(e)).toList()
            : [],
        page: json['page'],
        nextPage: json['nextPage'],
        totalPages: json['totalPages'],
        totalItems: json['totalItems'],
        total: json['total'],
      );
}
