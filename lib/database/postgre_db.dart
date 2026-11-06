import 'package:postgres/postgres.dart';

Future<void> connectToPostgreSQL() async {
  try {
    final postgreConn = await Connection.open(
      Endpoint(
        host: '10.25.1.16',
        port: 5432,
        database: 'sport-app-db',
        username: 'sportadmin',
        password: 'Thema3',
      ),
    );

    final result = await postgreConn.execute(
      Sql.named('''SELECT table_schema, table_name
             FROM information_schema.tables
             WHERE table_type = 'BASE TABLE'
             AND table_schema NOT IN ('pg_catalog', 'information_schema')
             ORDER BY table_schema, table_name;'''),
    );

    print(result);

    await postgreConn.close();
  } catch (e, stackTrace) {
    print('Fehler: $e');
    print(stackTrace);
  }
}