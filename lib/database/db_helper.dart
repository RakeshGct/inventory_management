import 'package:flutter/cupertino.dart';
import 'package:inventory_management/models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';



class DBHelper {
  final databaseName = 'inventoryApp.db';
  static String inventoryTableName = 'inventory';

  //Table for inventory app
  String inventoryTable = '''
  CREATE TABLE IF NOT EXISTS $inventoryTableName (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  sku TEXT,
  price INTEGER,
  quantity INTEGER
  )''';

  //Database connection
  Future<Database> initDB() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = "${databasePath.path}/$databaseName";
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(inventoryTable);
    });
  }

  //CRUD method
  //get inventory
  Future<List<Product>> getInventory() async {
    final db = await initDB();
    final List<Map<String, Object?>> res = await db.query(inventoryTableName);
    return res.map((e) => Product.fromMap(e)).toList();
  }

  //add Inventory
  Future<void> addInventory(Product product) async {
    final db = await initDB();
    db.insert(inventoryTableName, product.toMap());
  }

  //Update Inventory
  Future<void> updateInventory(Product product) async {
    final db = await initDB();
    db.update(inventoryTableName, product.toMap(), where: "id = ?", whereArgs: [product.id]);
  }

  //delete
  Future<void> deleteInventory(int id) async {
    final db = await initDB();
    db.delete(inventoryTableName, where: 'id = ?', whereArgs: [id]);
  }
}