/// ```dart
/// Where("age", WhereOperator.isGreaterThan, 40);
/// Where("age", WhereOperator.isGreaterThan, 40).and("gender", WhereOperator.isEqual, "M");
/// Where.not("age", WhereOperator.isGreaterThan, 40).and("gender", WhereOperator.isEqual, "M");
/// ```
class Where {
  Where(
    this.columnName,
    this.operator,
    this.value,
  );
  Where.not(
    this.columnName,
    this.operator,
    this.value,
  ) {
    prev = 'WHERE NOT';
  }

  final String columnName;
  final Object value;
  final WhereOperator operator;
  String prev = 'WHERE';

  String get query {
    // ignore: no_leading_underscores_for_local_identifiers
    Object _value = value is String ? "'$value'" : value;
    return '$prev "$columnName" ${operator.operator} $_value ';
  }

  Where or(
    String columnName,
    WhereOperator operator,
    Object value,
  ) {
    var where = Where(columnName, operator, value);
    where.prev = '$query OR ';
    return where;
  }

  Where and(
    String columnName,
    WhereOperator operator,
    Object value,
  ) {
    var where = Where(columnName, operator, value);
    where.prev = '$query AND ';
    return where;
  }

  Where andNot(
    String columnName,
    WhereOperator operator,
    Object value,
  ) {
    var where = Where(columnName, operator, value);
    where.prev = '$query AND NOT ';
    return where;
  }
}

enum WhereOperator {
  isEqual('='),
  isGreaterThan('>'),
  isLessThan('<'),
  isGreaterThanOrEqual('>='),
  isLessThanOrEqual('<='),
  isNotEqual('<>'),
  isBetween('BETWEEN'),
  isLike('LIKE'),
  isIn('IN'),
  isNull('IS NULL'),
  isNotNull('IS NOT NULL'),

  regXMatchesAndCaseSensitive('~'),
  regXMatchesAndCaseInsensitive('~*'),
  regXNotMatchesAndCaseSensitive('!~'),
  regXNotMatchesAndCaseInsensitive('!~*');

  final String operator;
  const WhereOperator(this.operator);
}
