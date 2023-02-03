class Aggregate {
  Aggregate({required this.type, required this.columnName, this.label, this.castToNumeric = false});
  final AggregateType type;
  final String columnName;
  final String? label;
  final bool castToNumeric;

  String get query{
    return '${type.label}("$columnName"${castToNumeric ? "::numeric" : ""}) ${label == null ? "" : "AS $label"}';
  }
}

enum AggregateType{
  count, sum, avg,
  min, max;

  String get label => name.toUpperCase();
}

class Count extends Aggregate {
  Count({required String columnName, String? label}):super(columnName: columnName, label: label, type: AggregateType.count,);
}
class Sum extends Aggregate {
  Sum({required String columnName, String? label}):super(columnName: columnName, label: label, type: AggregateType.sum, castToNumeric: true);
}
class Avg extends Aggregate {
  Avg({required String columnName, String? label}):super(columnName: columnName, label: label, type: AggregateType.avg, castToNumeric: true);
}