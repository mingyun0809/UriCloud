import 'package:mysql_client/mysql_client.dart';

Future<void> dbConnector() async {
  print("Connecting to mysql server...");

  final conn = await MySQLConnection.createConnection(
      host: "121.182.226.22",
      port: 3306,
      userName: "root",
      password: "@@rnal1004"
  );

  await conn.connect();

  print("Connected : $conn");

  await conn.close();

}