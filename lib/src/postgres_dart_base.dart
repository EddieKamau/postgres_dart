import 'package:postgres/postgres.dart';
import 'package:postgres_dart/src/postgres_table.dart';

class PostgresDb {
  PostgresDb({
    required this.host,
    this.port = 5432,
    required this.databaseName,
    required this.username,
    required this.password,
    int timeoutInSeconds = 30,
    int queryTimeoutInSeconds = 30,
    String timeZone = 'UTC',
    bool useSSL = false,
    bool isUnixSocket = false,
    bool allowClearTextPassword = false,
    ReplicationMode replicationMode = ReplicationMode.none,
  }) {
    db = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
      timeoutInSeconds: timeoutInSeconds,
      queryTimeoutInSeconds: queryTimeoutInSeconds,
      timeZone: timeZone,
      useSSL: useSSL,
      isUnixSocket: isUnixSocket,
      allowClearTextPassword: allowClearTextPassword,
      replicationMode: replicationMode,
    );
  }

  PostgresDb.fromUrl(
    String url, {
    this.port = 5432,
    int timeoutInSeconds = 30,
    int queryTimeoutInSeconds = 30,
    String timeZone = 'UTC',
    bool useSSL = false,
    bool isUnixSocket = false,
    bool allowClearTextPassword = false,
    ReplicationMode replicationMode = ReplicationMode.none,
  }) {
    var base = url.split('postgresql://');
    if (base.length > 1) {
      host = base[1].split('@').last.split('/')[0];
      databaseName = url.split('/').last;
      username = base[1].split(':').first;
      password = base[1].split('@').first.split(':').last;
    } else {
      host = '';
      databaseName = '';
      username = '';
      password = '';
    }

    db = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
      timeoutInSeconds: timeoutInSeconds,
      queryTimeoutInSeconds: queryTimeoutInSeconds,
      timeZone: timeZone,
      useSSL: useSSL,
      isUnixSocket: isUnixSocket,
      allowClearTextPassword: allowClearTextPassword,
      replicationMode: replicationMode,
    );
  }

  late PostgreSQLConnection db;

  late final String host;
  late final int port;
  late final String databaseName;
  late final String username;
  late final String password;

  Future open() => db.open();

  PostgresTable table(String tableName) =>
      PostgresTable(db: db, tableName: tableName);

  Future query(
    String query, {
    Map<String, dynamic>? substitutionValues,
    bool? allowReuse,
    int? timeoutInSeconds,
    bool? useSimpleQueryProtocol,
  }) =>
      db.query(query,
          substitutionValues: substitutionValues,
          allowReuse: allowReuse,
          timeoutInSeconds: timeoutInSeconds,
          useSimpleQueryProtocol: useSimpleQueryProtocol);
}
