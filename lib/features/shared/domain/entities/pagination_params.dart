class PaginationParams {
  final int page;
  final int limit;

  const PaginationParams({
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };
}
