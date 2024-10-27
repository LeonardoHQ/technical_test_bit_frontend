/// --- Server Success.
/// Used when connections to servers are successful
class SS<T> {
  ResponsePageInfo? pageInfo;

  List<T> multiple = [];
  T? single;
  SS({this.multiple = const [], this.pageInfo, this.single});
}

/// --- Server Error.
/// Used when connections to servers have errors
class SE {
  final String detail;

  SE({required this.detail});
}

class BasePageInfo {
  final int page;
  final int pageSize;

  BasePageInfo({required this.page, required this.pageSize});
}

// Standar page info responses for GET endpoints,
class ResponsePageInfo extends BasePageInfo {
  final int total;

  ResponsePageInfo(
      {required this.total, required super.page, required super.pageSize});

  factory ResponsePageInfo.fromJson(Map<String, dynamic> data) =>
      ResponsePageInfo(
          page: data['page'], pageSize: data['pageSize'], total: data['total']);

  int get totalPages => (total / pageSize).ceil();

  bool get isLastPage => page == totalPages;
}

// Standar page info requests for GET endpoints, used to filter
class RequestPageInfo extends BasePageInfo {
  RequestPageInfo({required super.page, required super.pageSize});
}
