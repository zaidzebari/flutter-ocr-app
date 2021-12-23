import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static Database? _database;
  static final DBProvider db = DBProvider._();

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "ocr_data.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Menu ("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "created_at TEXT"
            ")");
        await db.execute("CREATE TABLE SubCategory ("
            "id INTEGER PRIMARY KEY,"
            "menuId INTEGER,"
            "pin TEXT,"
            "serial TEXT,"
            "price TEXT,"
            "created_on TEXT"
            ")");
      },
    );
  }

  //accepted as insert method

  insertMenu(String table, Map<String, dynamic> data) async {
    final db = await database;
    var raw = await db.insert(table, data);
    //return id
    return raw;
  }

  getMaxMenuId() async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Menu");
    return table;
  }

  getMenus() async {
    final db = await database;

    var res = await db.query("Menu");
    // var res = await db.query("Menu", where: "id = ?", whereArgs: [id]);
    // return res.isNotEmpty ? Client.fromMap(res.first) : Null;
    return res;
  }

  insertSubCategory(String table, Map<String, dynamic> data) async {
    final db = await database;
    var raw = await db.insert(table, data);
    //return id
    return raw;
  }

  deleteMenu(int? id) async {
    final db = await database;
    db.delete("Menu", where: "id = ?", whereArgs: [id]);
    db.delete("SubCategory", where: "menuId = ?", whereArgs: [id]);
  }

  getSubCategory(int? menuId) async {
    final db = await database;
    var res =
        await db.query("SubCategory", where: "menuId = ?", whereArgs: [menuId]);
    // return res.isNotEmpty ? Client.fromMap(res.first) : Null;
    return res;
  }

  getSubCategoryId() async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM SubCategory");
    return table;
  }

  deleteSubCategory(int? id) async {
    final db = await database;
    db.delete("SubCategory", where: "id = ?", whereArgs: [id]);
  }

  // Future<List<Menu>> getAllClients() async {
  //   final db = await database;
  //   var res = await db.rawQuery("SELECT * FROM Client"); // db.query("Client");
  //   //this also work
  //   // List<Client> mylist = [];
  //   // res.forEach((element) {
  //   //   mylist.add(Client.fromMap(element));
  //   // });
  //   // List<Menu> list =
  //   //     res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   // return list;
  // }

  // getBlockedClients() async {
  //   final db = await database;
  //   var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }

  // updateClient(Client newClient) async {
  //   final db = await database;
  //   var res = await db.update("Client", newClient.toMap(),
  //       where: "id = ?", whereArgs: [newClient.id]);
  //   return res;
  // }

  // blockOrUnblock(Client client) async {
  //   final db = await database;
  //   Client blocked = Client(
  //       id: client.id,
  //       firstName: client.firstName,
  //       lastName: client.lastName,
  //       blocked: !client.blocked);
  //   var res = await db.update("Client", blocked.toMap(),
  //       where: "id = ?", whereArgs: [client.id]);
  //   return res;
  // }

  deleteClient(int id) async {
    final db = await database;
    db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Client");
  }
}
