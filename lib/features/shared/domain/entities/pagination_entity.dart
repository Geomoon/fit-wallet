class PaginationEntity<T> {
  List<T> items;
  int page;
  int? nextPage;
  int totalPages;
  int totalItems;
  int total;

  PaginationEntity({
    required this.items,
    required this.page,
    this.nextPage,
    this.totalPages = 0,
    this.totalItems = 0,
    this.total = 0,
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
