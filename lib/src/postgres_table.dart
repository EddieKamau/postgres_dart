import 'package:postgres/postgres.dart';
import 'package:postgres_dart/src/aggregate.dart';
import 'package:postgres_dart/src/column.dart';
import 'package:postgres_dart/src/joins.dart';
import 'package:postgres_dart/src/min_max.dart';
import 'package:postgres_dart/src/order_by.dart';
import 'package:postgres_dart/src/where.dart';

class PostgresTable {
  PostgresTable({required this.db, required this.tableName});
  final PostgreSQLConnection db;
  final String tableName;

  String getQuery({
    Where? where, 
    OrderBy? orderBy,  
    int? limit,
    List<String>? groupBy
  }) {
    return '${where == null ? "" : where.query} ${groupBy == null ? "" : "GROUP BY ${groupBy.map((e) => '"$e"',).join(",")}"} ${orderBy == null ? "" : orderBy.query} ${limit == null ? "" : "LIMIT $limit"}';
  }

  // select
  Future<DbResponse> select({
    Where? where, 
    OrderBy? orderBy, 
    List<Column> columns = const [], 
    bool distinct = false,
    int? limit,
  })async{
    // ignore: no_leading_underscores_for_local_identifiers
    String _fields = columns.isEmpty ? '*' : columns.join(',');
    String query = 'SELECT ${distinct ? "DISTINCT " : ''}$_fields FROM "$tableName" ${getQuery(where: where, orderBy: orderBy, limit:limit)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));
  }

  // min 
  Future<DbResponse> min(List<Min> min, {Where? where,})async{
    String query = 'SELECT ${(min.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));
  }

  // max
  Future<DbResponse> max(List<Max> max, {Where? where,})async{
    String query = 'SELECT ${(max.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));
  }

  // count
  Future<DbResponse> count(List<Count> count, {Where? where,})async{
    String query = 'SELECT ${(count.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));

  }

  // sum
  Future<DbResponse> sum(List<Sum> sum, {Where? where,})async{
    String query = 'SELECT ${(sum.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));

  }

  // avg
  Future<DbResponse> avg(List<Sum> sum, {Where? where,})async{
    String query = 'SELECT ${(sum.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));

  }

  // Aggregate
  Future<DbResponse> aggregate(List<Aggregate> aggregates, {Where? where,})async{
    String query = 'SELECT ${(aggregates.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));

  }

  // group
  Future<DbResponse> group({
    required List<String> groupBy,
    List<Column>? columns,
    List<Aggregate>? aggregates, 
    Where? where, 
    OrderBy? orderBy
    }
  )async{
    String query = 'SELECT ${columns == null ? "" : "${columns.join(",")},"} ${aggregates == null ? "" : (aggregates.map((e) => e.query)).join(", ")} FROM "$tableName" ${getQuery(where: where, groupBy: groupBy, orderBy: orderBy)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));

  }

  // joins
  Future<DbResponse> join({
    List<Column> columns = const [],
    required List<Join> joins, 
    String? tableAs,
    Where? where, OrderBy? orderBy, int? limit
  })async{
    String query = 'SELECT ${columns.isEmpty ? "*" : columns.join(",")} FROM $tableName ${tableAs == null ? "" : "AS $tableAs"} ${joins.map((e) => e.query,).join(" ")} ${getQuery(where: where, orderBy: orderBy, limit: limit)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));

  }


  // update

  // insert

  // delete
  Future<DbResponse> delete(Where where)async{
    String query = 'DELETE FROM $tableName ${getQuery(where: where,)}';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));
  }

  // deleteAll
  Future<DbResponse> deleteAll()async{
    String query = 'DELETE FROM $tableName';
    var dbRes = await db.query(query);

    return DbResponse(dbRes.columnDescriptions.map((e) => e.columnName).toList(), List<List>.from(dbRes.toList()));
  }

  // transaction
}

class DbResponse {
  DbResponse(this.columnNames, this.data);
  List<String> columnNames;
  List<List> data;

  List<Map<String, dynamic>> asListMap(){
    return [
      for(int i=0; i<data.length; i++)
        {
          for(int keyIndex=0; keyIndex < columnNames.length; keyIndex++)
            columnNames[keyIndex]: data[i][keyIndex]
        }
    ];
  }

  @override
  String toString()=> asListMap().toString();
}