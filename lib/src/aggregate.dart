/// [Aggregate] functions such as [Count], [Sum], [Avg], min and max
/// [columnName] The Column being aggregated; ie, ```SUM("amount")``` where ```amount``` is the [columnName]
/// [label] is used for the column name; ie: ```sum("amount") as myTotal```, where myTotal is the label
/// [castToNumeric] is used when the some or all the values in the columns are saved as String(varchar) but are numbers; converts ```"10"``` to 10
///
/// Can be used directly
/// ``` dart
/// Aggregate(type: AggregateType.count, columnName: "*");
/// Aggregate(type: AggregateType.sum, columnName: "amount", label: "totalAmount", castToNumeric: true);
/// ```
/// or by using it's helper Objects
/// ```dart
///   Count(columnName: "*");
///   Avg(columnName: "amount");
///   Sum(columnName: "amount", label: "totalAmount",);
/// ```
///
class Aggregate {
  Aggregate(
      {required this.type,
      required this.columnName,
      this.label,
      this.castToNumeric = false});
  final AggregateType type;
  final String columnName;
  final String? label;
  final bool castToNumeric;

  String get query {
    return '${type.label}("$columnName"${castToNumeric ? "::numeric" : ""}) ${label == null ? "" : "AS $label"}';
  }
}

enum AggregateType {
  count,
  sum,
  avg,
  min,
  max;

  String get label => name.toUpperCase();
}

/// [Count] returns the total row count for the query
class Count extends Aggregate {
  Count({required String columnName, String? label})
      : super(
          columnName: columnName,
          label: label,
          type: AggregateType.count,
        );
}

/// [Sum] returns the total sum for specified column
class Sum extends Aggregate {
  Sum({required String columnName, String? label})
      : super(
            columnName: columnName,
            label: label,
            type: AggregateType.sum,
            castToNumeric: true);
}

/// [Avg] returns the average for specified column
class Avg extends Aggregate {
  Avg({required String columnName, String? label})
      : super(
            columnName: columnName,
            label: label,
            type: AggregateType.avg,
            castToNumeric: true);
}
