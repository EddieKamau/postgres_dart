/// [columnName] is the column name as in the table
/// [columnAs] is name of the column on the response
class Column {
  Column(this.columnName, {this.columnAs});
  final String columnName;
  final String? columnAs;

  @override
  String toString()=> '$columnName${columnAs == null ? "" : " AS $columnAs"}';
}