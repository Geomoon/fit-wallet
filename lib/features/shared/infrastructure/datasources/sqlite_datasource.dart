import 'package:fit_wallet/config/env/env.dart';
import 'package:fit_wallet/features/categories/infrastructure/mappers/mappers.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDatasource {
  static late final Database? _db;

  static final SQLiteDatasource _instance = SQLiteDatasource._internal();

  factory SQLiteDatasource() {
    return _instance;
  }

  SQLiteDatasource._internal();

  static initDB() async {
    _db = await openDatabase(
      Env.dbName,
      onOpen: (db) {
        debugPrint('DB OPENED: ${db.path}');
      },
      onCreate: (db, version) async {
        await createTables(db);
        await createFirstAccount(db);
        await insertCategories(db);
        debugPrint('TABLES HAS BEEN CREATED');
      },
      version: 1,
    );
  }

  Database get db => _db!;

  static Future<void> createFirstAccount(Database db) async {
    await db.insert('money_accounts', {
      'macc_id': Utils.uuid,
      'macc_name': 'PERSONAL',
      'macc_amount': 0,
      'macc_order': 0,
      'macc_created_at': Utils.now,
    });
  }

  static Future<void> createTables(Database db) async {
    final batch = db;

    debugPrint(db.path);

    await batch.execute('''
      CREATE TABLE IF NOT EXISTS money_accounts (
        macc_id TEXT,
        macc_name TEXT,
        macc_amount REAL,
        macc_order INTEGER,
        macc_created_at INTEGER,
        macc_updated_at INTEGER,
        macc_deleted_at INTEGER,
        user_id INTEGER,
        PRIMARY KEY ( macc_id )
      );
    ''');

    await batch.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        cate_id TEXT,
        cate_name TEXT,
        cate_hex_color TEXT,
        cate_icon TEXT,
        cate_is_default INTEGER,
        cate_created_at INTEGER,
        cate_updated_at INTEGER,
        cate_deleted_at INTEGER,
        user_id INTEGER,
        PRIMARY KEY ( cate_id )
      );
    ''');

    await batch.execute('''
      CREATE TABLE IF NOT EXISTS transactions (
        tran_id TEXT,
        tran_description TEXT,
        tran_amount REAL,
        tran_type TEXT,
        tran_created_at INTEGER,
        tran_deleted_at INTEGER,
        macc_id TEXT,
        macc_id_transfer TEXT,
        cate_id TEXT,
        debt_id TEXT,
        PRIMARY KEY ( tran_id ),
        FOREIGN KEY ( macc_id ) REFERENCES money_accounts ( macc_id ),
        FOREIGN KEY ( macc_id_transfer ) REFERENCES money_accounts ( macc_id ),
        FOREIGN KEY ( cate_id ) REFERENCES categories ( cate_id )
      );
    ''');
  }

  static insertCategories(Database db) async {
    final categoriesJson =
        await Utils.readJsonFile('assets/data/categories.json');

    final categories = (categoriesJson as List)
        .map((e) => CategoriesMapper.fromJsonDb(e))
        .toList();

    await Future.wait(
      categories.map(
        (e) => db.insert('categories', CategoriesMapper.toJsonDb(e)),
      ),
    ).whenComplete(() => debugPrint('CATEGORIES INSERTED'));
  }
}
