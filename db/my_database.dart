import 'package:mysql_client/mysql_client.dart';

class MyDatabase {
  static MySQLConnection? conn;

  static Future<void> getConnection() async {
    try {
      conn = await MySQLConnection.createConnection(
          host: "121.182.226.22",
          port: 3306,
          userName: "root",
          password: "@@rnal1004",
          databaseName: "uri_db");
      await conn!.connect();
      print("Connected");
    } catch (e) {
      print("Error getting connection: $e");
    }
  }

  static Future<void> insertRawMaterial(
      String materialName, String classcification, String stockUnit) async {
    try {
      if (conn == null) {
        await getConnection();
      }
      await conn?.execute(
          "INSERT INTO raw_materials (material_name, classcification, stock_unit) VALUES (:materialName, :classcification, :stockUnit)",
          {
            "materialName": materialName,
            "classcification": classcification,
            "stockUnit": stockUnit,
          }
      );
      print("Result : $materialName\n$classcification\n$stockUnit");
    } catch (e) {
      print("Error inserting raw material: $e");
    }

  }

  static Future<List<Map<String, String>>> getRawMaterials() async {
      final result = await conn?.execute('SELECT material_id, material_name, classcification, stock_unit FROM raw_materials');
      List<Map<String, String>> materials = [];

      if(result != null) {
        for(final row in result.rows) {
          materials.add({
            'material_id': row.colAt(0)?? '',
            'material_name': row.colAt(1) ?? '',
            'stock_unit' : row.colAt(2) ?? '',
            'classcification': row.colAt(3) ?? '',
          });
        }
      }
      return materials;
  }

  static Future<void> updateRawMaterial(String id, String materialName, String classcification, String stockUnit) async {
    try {
      if(conn == null) {
        await getConnection();
      }
      await conn?.execute(
        'UPDATE raw_materials SET material_name = :materialName, classcification = :classcification, stock_unit = :stockUnit WHERE material_id = :id',
        {
          "id": id,
          "materialName":materialName,
          "classcification":classcification,
          "stock_unit":stockUnit,
        },
      );
      print("Updated Material : $materialName\n$classcification\n$stockUnit");
    } catch(e) {
      print("Error updating raw material: $e");
    }
  }

  static Future<void> deleteRawMaterial(String id) async {
    try {
      if(conn == null) {
        await getConnection();
      }
      await conn?.execute(
        'DELETE FROM raw_materials WHERE material_id = :id',
        {
          "id": id,
        },
      );
      print("Deleted Material with ID : $id");
    } catch(e) {
      print("Error deleting raw material:$e");
    }
  }

  static Future<void> closeConnection() async {
    try {
      await conn?.close();
      print("Connection closed");
    } catch (e) {
      print("Error closing Connection : $e");
    }
  }
}
