/// For multiple order by, use [OrderBy.and]
/// ie;
/// ```dart
///   OrderBy("date");
///   OrderBy("date").and(OrderBy("name", ascending: false));
/// ```
class OrderBy {
  OrderBy(this.columnName, {this.ascending});
  final String columnName;
  final bool? ascending;

  String prev = 'ORDER BY ';

  String get query =>
      '$prev $columnName ${ascending == null ? "" : ascending! ? "ASC" : "DESC"}';

  OrderBy and(OrderBy orderBy) {
    orderBy.prev = '$query, ';
    return orderBy;
  }
}
