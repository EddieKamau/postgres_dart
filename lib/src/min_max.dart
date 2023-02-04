import 'package:postgres_dart/src/aggregate.dart';

/// Returns the minimum Value in the given column
class Min extends Aggregate{
  Min(String columnName, {bool castToNumeric = false, String? label}):super(type: AggregateType.min, columnName: columnName, label: label, castToNumeric: castToNumeric);
}

/// Returns the maximum Value in the given column
class Max extends Aggregate{
  Max(String columnName, {bool castToNumeric = false, String? label}):super(type: AggregateType.max, columnName: columnName, label: label, castToNumeric: castToNumeric);
}
