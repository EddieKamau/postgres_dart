import 'package:postgres_dart/src/where.dart' show WhereOperator;

class Join{
  Join({required this.joinType, required this.tableName, required this.onorUsing, this.tableAs});
  final String tableName;
  final String? tableAs;
  final JoinType joinType;
  final OnorUsing onorUsing;

  String get query{
    return '${joinType.value} "$tableName" ${tableAs == null ? "" : "AS $tableAs"} ${onorUsing.query} ';
  }

}

enum JoinType{
  inner('INNER JOIN'),
  left('LEFT JOIN'),
  right('RIGHT JOIN'),
  outer('FULL OUTER JOIN');

  final String value;
  const JoinType(this.value);
}

class OnorUsing {
  OnorUsing(this.query);
  String query;
}

class JoinOn extends OnorUsing {
  JoinOn({
    required this.leftColumnName, required this.rightColumnName, required this.operator,
  }):super('ON $leftColumnName ${operator.operator} $rightColumnName');

  final String leftColumnName;
  final String rightColumnName;
  final WhereOperator operator;
  
}

class JoinUsing extends OnorUsing {
  JoinUsing({
    required this.columnName,
  }):super('USING ($columnName)');
  
  final String columnName;
  
}

