import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:postgres_dart/src/aggregate.dart';
import 'package:postgres_dart/src/column.dart';
import 'package:postgres_dart/src/joins.dart';
import 'package:postgres_dart/src/min_max.dart';
import 'package:postgres_dart/src/order_by.dart';
import 'package:postgres_dart/src/where.dart';

/// Contains Table methods such as [select], [insert], [update], [delete], [deleteAll], [min], [max], [count], [sum], [avg], [aggregate], [group], [join]
class PostgresTable {
  PostgresTable({required this.db, required this.tableName});
  final PostgreSQLConnection db;
  final String tableName;

  String getQuery(
      {Where? where, OrderBy? orderBy, int? limit, List<String>? groupBy}) {
    return '${where == null ? "" : where.query} ${groupBy == null ? "" : "GROUP BY ${groupBy.map(
          (e) => '"$e"',
        ).join(",")}"} ${orderBy == null ? "" : orderBy.query} ${limit == null ? "" : "LIMIT $limit"}';
  }

  // select
  Future<DbResponse> select({
    Where? where,
    OrderBy? orderBy,
    List<Column> columns = const [],
    bool distinct = false,
    int? limit,
  }) async {
    // ignore: no_leading_underscores_for_local_identifiers
    String _fields = columns.isEmpty ? '*' : columns.join(',');
    String query =
        'SELECT ${distinct ? "DISTINCT " : ''}$_fields FROM "$tableName" ${getQuery(where: where, orderBy: orderBy, limit: limit)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // min
  /// ```dart
  ///   min([Min("amount", label: "minAmount")]);
  ///   min([Min("amount", label: "minAmount"), Min("age", label: "minAge"),], where: Where("age",WhereOperator.isGreaterThan , 40));
  /// ```
  Future<DbResponse> min(
    List<Min> min, {
    Where? where,
  }) async {
    String query =
        'SELECT ${(min.map((e) => e.query)).map((val)=>'"$val"').join(', ')} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // max
  /// ```dart
  ///   max([Max("amount", label: "maxAmount")]);
  ///   max([Max("amount", label: "maxAmount"), Min("age", label: "maxAge"),], where: Where("age",WhereOperator.isGreaterThan , 40));
  /// ```
  Future<DbResponse> max(
    List<Max> max, {
    Where? where,
  }) async {
    String query =
        'SELECT ${(max.map((e) => e.query)).map((val)=>'"$val"').join(', ')} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // count
  /// ```dart
  ///   count([Count("*")]);
  ///   count([Count("*")], where: Where("age",WhereOperator.isGreaterThan , 40));
  /// ```
  Future<DbResponse> count(
    List<Count> count, {
    Where? where,
  }) async {
    String query =
        'SELECT ${(count.map((e) => e.query)).map((val)=>'"$val"').join(', ')} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // sum
  /// ```dart
  ///   sum([Sum("amount",)]);
  ///   sum([Sum("amount", label: "totalAmount")], where: Where("age",WhereOperator.isGreaterThan , 40));
  /// ```
  Future<DbResponse> sum(
    List<Sum> sum, {
    Where? where,
  }) async {
    String query =
        'SELECT ${(sum.map((e) => e.query)).map((val)=>'"$val"').join(', ')} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // avg
  /// ```dart
  ///   avg([Avg("amount",)]);
  ///   avg([Acg("amount", label: "averageAmount")], where: Where("age",WhereOperator.isGreaterThan , 40));
  /// ```
  Future<DbResponse> avg(
    List<Avg> avg, {
    Where? where,
  }) async {
    String query =
        'SELECT ${(avg.map((e) => e.query)).map((val)=>'"$val"').join(', ')} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // Aggregate
  /// ```dart
  ///   aggregate(
  ///     [
  ///       Sum("amount", label: "totalAmount"),
  ///       Avg("amount", label: "averageAmount"),
  ///       Max("amount", label: "maxAmount", castToNumeric: true),
  ///       Min("amount", label: "minAmount"),
  ///       Count("amount"),
  ///     ]
  ///   );
  ///
  ///   aggregate([Sum("amount", label: "totalAmount")], where: Where("age",WhereOperator.isGreaterThan , 40));
  /// ```
  Future<DbResponse> aggregate(
    List<Aggregate> aggregates, {
    Where? where,
  }) async {
    String query =
        'SELECT ${(aggregates.map((e) => e.query)).map((val)=>'"$val"').join(', ')} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // group
  Future<DbResponse> group(
      {required List<String> groupBy,
      List<Column>? columns,
      List<Aggregate>? aggregates,
      Where? where,
      OrderBy? orderBy}) async {
    String query =
        'SELECT ${columns == null ? "" : "${columns.map((val)=>'"$val"').join(',')},"} ${aggregates == null ? "" : (aggregates.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where, groupBy: groupBy, orderBy: orderBy)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // joins
  Future<DbResponse> join(
      {List<Column> columns = const [],
      required List<Join> joins,
      String? tableAs,
      Where? where,
      OrderBy? orderBy,
      int? limit}) async {
    String query =
        'SELECT ${columns.isEmpty ? "*" : columns.map((val)=>'"$val"').join(',')} FROM "$tableName" ${tableAs == null ? "" : "AS $tableAs"} ${joins.map(
              (e) => e.query,
            ).join(" ")} ${getQuery(where: where, orderBy: orderBy, limit: limit)}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // insert
  Future<DbResponse> insert({
    required List values,
    List<String>? columns,
  }) async {
    // ignore: no_leading_underscores_for_local_identifiers
    List<String> _values = values.map((e) {
      if (e is String) {
        return "'$e'";
      }else if (e is List) {
        return "'${_listValue(e)}'";
      } else {
        return e.toString();
      }
    }).toList();
    String query =
        'INSERT INTO  "$tableName" ${columns == null ? "" : "(${columns.map((val)=>'"$val"').join(',')})"} VALUES (${_values.join(",")})';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // update
  /// ```dart
  /// update(
  ///   update: {
  ///     "column1": "new value",
  ///     "age": 60
  ///   },
  ///   where: Where("id", WhereOperator.isEqual, 12)
  /// );
  /// ```
  Future<DbResponse> update({
    required Map<String, dynamic> update,
    required Where? where,
  }) async {
    // ignore: no_leading_underscores_for_local_identifiers
    List<String> _values = [];

    for (var key in update.keys) {
      String val =
          update[key] is String ? "'${update[key]}'": update[key] is List ? "'${_listValue(update[key])}'" : update[key].toString();
      _values.add('"$key" = $val');
    }
    if (_values.isEmpty) return DbResponse([], []);

    // ignore: no_leading_underscores_for_local_identifiers
    String _value = _values.join(', ');

    String query = ' UPDATE "$tableName" SET $_value ${getQuery(
      where: where,
    )}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // delete
  Future<DbResponse> delete(Where where) async {
    String query = 'DELETE FROM "$tableName" ${getQuery(
      where: where,
    )}';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  // deleteAll
  Future<DbResponse> deleteAll() async {
    String query = 'DELETE FROM "$tableName"';
    var dbRes = await db.query(query);

    return DbResponse(
        dbRes.columnDescriptions.map((e) => e.columnName).toList(),
        List<List>.from(dbRes.toList()));
  }

  String _listValue(List val){
    var res = json.encode(val);
    res = res.replaceFirst('[', '{');
    res = res.replaceFirst(']', '}');
    return res;
  }

  // transaction
}

class DbResponse {
  DbResponse(this.columnNames, this.data);
  List<String> columnNames;
  List<List> data;

  List<Map<String, dynamic>> asListMap() {
    return [
      for (int i = 0; i < data.length; i++)
        {
          for (int keyIndex = 0; keyIndex < columnNames.length; keyIndex++)
            columnNames[keyIndex]: data[i][keyIndex]
        }
    ];
  }

  @override
  String toString() => asListMap().toString();
}
