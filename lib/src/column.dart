class Column {
  Column(this.columnName, {this.columnAs});
  final String columnName;
  final String? columnAs;

  @override
  String toString()=> '$columnName${columnAs == null ? "" : " AS $columnAs"}';
}