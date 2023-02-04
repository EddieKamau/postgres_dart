import 'package:postgres_dart/postgres_dart.dart';

Future<void> main() async {
  var db =
      PostgresDb.fromUrl('postgresql://username:password@hosturl/databaseName');
  await db.open();

  // insert
  await db
      .table('tableName')
      .insert(columns: ['name', 'age'], values: ['Name Name', 30]);

  // update
  await db.table('tableName').update(
      update: {"age": 40},
      where: Where('name', WhereOperator.isEqual, 'Name Name'));
  // update all
  await db.table('tableName').update(update: {"age": 40}, where: null);

  // delete
  await db
      .table('tableName')
      .delete(Where('name', WhereOperator.isEqual, 'Name Name'));
  await db.table('tableName').deleteAll();

  // fetch
  await db.table('tableName').select(
      columns: [
        Column('id'),
        Column('name', columnAs: 'userName'),
        Column('age')
      ],
      where: Where('name', WhereOperator.isEqual, 'Name Name'),
      orderBy: OrderBy('name', ascending: true));

  // max, min,
  await db.table('tableName').max([Max('age')]);
  await db.table('tableName').min([Min('age', label: 'minAge')]);

  // count
  await db.table('tableName').count([Count(columnName: '*')]);

  // sum, avg
  await db.table('tableName').sum(
      [Sum(columnName: 'age', label: 'totalAge'), Sum(columnName: 'amount')]);
  await db.table('tableName').avg(
      [Avg(columnName: 'age', label: 'averageAge'), Avg(columnName: 'amount')]);

  // aggregate
  await db.table('tableName').aggregate([
    Count(columnName: '*'),
    Sum(columnName: 'amount', label: 'totalAmount'),
    Avg(columnName: 'age', label: 'averageAge'),
  ]);

  // group
  await db.table('tableName').group(groupBy: [
    'gender'
  ], columns: [
    Column('gender')
  ], aggregates: [
    Count(columnName: '*'),
    Sum(columnName: 'amount', label: 'totalAmount'),
    Avg(columnName: 'age', label: 'averageAge'),
  ]);

  // join
  await db.table('tableName').join(tableAs: 't1', columns: [
    Column('t1.id', columnAs: 'id'),
    Column('t1.name', columnAs: 'name'),
    Column('t3.age', columnAs: 'age'),
  ], joins: [
    Join(
        joinType: JoinType.inner,
        tableName: 'table2',
        tableAs: 't2',
        onorUsing: JoinOn(
            leftColumnName: 't1.id',
            rightColumnName: 't2.userid',
            operator: WhereOperator.isEqual)),
    Join(
        joinType: JoinType.inner,
        tableName: 'table3',
        tableAs: 't3',
        onorUsing: JoinUsing(columnName: 'userid')),
  ]);
}
