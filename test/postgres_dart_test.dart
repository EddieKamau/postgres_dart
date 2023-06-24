import 'package:postgres_dart/postgres_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Aggregates', () {
    test('Base Aggregate', () {
      Aggregate aggregate =
          Aggregate(type: AggregateType.sum, columnName: 'amount');
      expect(aggregate.query, 'SUM("amount") ');

      Aggregate aggregate2 = Aggregate(
          type: AggregateType.sum, columnName: 'amount', label: 'totalAmount');
      expect(aggregate2.query, 'SUM("amount") AS totalAmount');

      Aggregate aggregate3 = Aggregate(
          type: AggregateType.sum,
          columnName: 'amount',
          label: 'totalAmount',
          castToNumeric: true);
      expect(aggregate3.query, 'SUM("amount"::numeric) AS totalAmount');
    });

    test('Sum', () {
      Sum sum = Sum(columnName: 'amount');
      expect(sum.query, 'SUM("amount"::numeric) ');
    });
    test('Avg', () {
      Avg avg = Avg(columnName: 'amount');
      expect(avg.query, 'AVG("amount"::numeric) ');
    });
    test('Count', () {
      Count count = Count(columnName: 'amount');
      expect(count.query, 'COUNT("amount") ');
    });
    test('Min', () {
      Min min = Min('amount');
      expect(min.query, 'MIN("amount") ');
    });
    test('Max', () {
      Max max = Max('amount');
      expect(max.query, 'MAX("amount") ');
    });
  });

  group('Column', () {
    test('Column', () {
      Column column = Column('amount');
      expect(column.toString(), 'amount');
      Column column2 = Column('amount', columnAs: 'new');
      expect(column2.toString(), 'amount AS new');
    });
  });

  group('Join', () {
    test('Base Join', () {
      Join join = Join(
          joinType: JoinType.inner,
          tableName: 'myTable',
          onorUsing: JoinOn(
              leftColumnName: 'leftColumnName',
              rightColumnName: 'rightColumnName',
              operator: WhereOperator.isEqual));
      expect(join.query,
          'INNER JOIN "myTable"  ON leftColumnName = rightColumnName ');
      Join join2 = Join(
          joinType: JoinType.outer,
          tableName: 'myTable',
          onorUsing: JoinUsing(
            columnName: 'columnName',
          ));
      expect(join2.query, 'FULL OUTER JOIN "myTable"  USING (columnName) ');
      Join join3 = Join(
          joinType: JoinType.left,
          tableName: 'myTable',
          tableAs: 'mt',
          onorUsing: JoinUsing(
            columnName: 'columnName',
          ));
      expect(join3.query, 'LEFT JOIN "myTable" AS mt USING (columnName) ');
    });
  });

  group('OrderBy', () {
    test('OrderBy', () {
      OrderBy orderBy = OrderBy('columnName');
      expect(orderBy.query, 'ORDER BY  columnName ');
      OrderBy orderBy2 = OrderBy('columnName', ascending: true);
      expect(orderBy2.query, 'ORDER BY  columnName ASC');
      OrderBy orderBy3 = OrderBy('columnName', ascending: false);
      expect(orderBy3.query, 'ORDER BY  columnName DESC');
    });
  });

  group('Where', () {
    test('Where', () {
      Where where = Where('columnName', WhereOperator.isEqual, 10);
      expect(where.query(), 'WHERE "columnName" = 10 ');
    });
    test('Where not', () {
      Where where = Where.not('columnName', WhereOperator.isBetween, 10);
      expect(where.query(), 'WHERE NOT "columnName" BETWEEN 10 ');
    });
    test('Where or', () {
      Where where = Where('columnName', WhereOperator.isEqual, 10)
          .or('columnName2', WhereOperator.isIn, [1, 2, 3]);
      expect(where.query(),
          'WHERE "columnName" = 10  OR  "columnName2" IN [1, 2, 3] ');
    });
    test('Where and', () {
      Where where = Where('columnName', WhereOperator.isLessThanOrEqual, 10)
          .and('columnName2', WhereOperator.isGreaterThan, 50);
      expect(
          where.query(), 'WHERE "columnName" <= 10  AND  "columnName2" > 50 ');
    });
    test('Where and not', () {
      Where where = Where('columnName', WhereOperator.isLike, 10)
          .andNot('columnName2', WhereOperator.isNotEqual, 50);
      expect(where.query(),
          'WHERE "columnName" LIKE 10  AND NOT  "columnName2" <> 50 ');
    });
  });
}
