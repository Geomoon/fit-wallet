class PaginationParams {
  int page;
  int limit;

  PaginationParams({
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };
}
