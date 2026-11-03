import 'package:postgres/postgres.dart';

Future<void> connectToPostgreSQL() async {
  try {
    final postgreConn = await Connection.open(
      Endpoint(
        host: '10.25.1.16',
        port: 5432,
        database: 'postgres',
        username: 'postgres',
        password: '',
      ),
    );

    final result = await postgreConn.execute(
      Sql.named('SELECT count(*) FROM "Disziplin"'),
    );

    print(result);

    await postgreConn.close();
  } catch (e, stackTrace) {
    print('Fehler: $e');
    print(stackTrace);
  }
}