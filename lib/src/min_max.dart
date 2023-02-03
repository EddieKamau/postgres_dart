// class MinMax {
//   MinMax({required this.type, required this.columnName, this.label});
//   final String columnName;
//   final String? label;
//   final MinMaxType type;

//   String get query{
//     return '${type.label}("$columnName") ${label == null ? "" : "AS $label"}';
//   }
// }


import 'package:postgres_dart/src/aggregate.dart';

class Min extends Aggregate{
  Min(String columnName, {bool castToNumeric = false, String? label}):super(type: AggregateType.min, columnName: columnName, label: label, castToNumeric: castToNumeric);
}

class Max extends Aggregate{
  Max(String columnName, {bool castToNumeric = false, String? label}):super(type: AggregateType.max, columnName: columnName, label: label, castToNumeric: castToNumeric);
}

enum MinMaxType{
  min('MIN'), max('MAX');

  final String label;
  const MinMaxType(this.label);
}