import 'dart:developer';

import 'package:fit_wallet/features/money_accounts/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/money_accounts/domain/entities/entities.dart';
import 'package:fit_wallet/features/money_accounts/infrastructure/mappers/money_account_mapper.dart';
import 'package:fit_wallet/features/shared/infrastructure/exceptions/exceptions.dart';
import 'package:fit_wallet/features/shared/infrastructure/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class MoneyAccountDbDatasource implements MoneyAccountDatasource {
  MoneyAccountDbDatasource(this._db);

  final Database _db;

  static const String table = 'money_accounts';

  @override
  Future<bool> archiveById(String id) async {
    await _db.update(
      table,
      {'macc_deleted_at': Utils.now},
      where: 'macc_id = ?',
      whereArgs: [id],
    );

    return true;
  }

  @override
  Future<bool> create(CreateMoneyAccountEntity entity) async {
    Map<String, dynamic> data = Map.from(entity.toJson());

    final id = Utils.uuid;
    final order = await getLastOrder();

    data['macc_id'] = id;
    data['macc_order'] = order + 1;
    data['macc_created_at'] = Utils.now;

    try {
      await _db.insert(table, data);
      return true;
    } catch (e) {
      log('ERROR DB', error: e);
      return false;
    }
  }

  @override
  Future<bool> deleteById(String id) async {
    await _db.update(
      table,
      {'macc_deleted_at': Utils.now},
      where: 'macc_id = ?',
      whereArgs: [id],
    );

    return true;
  }

  @override
  Future<List<MoneyAccountLastTransactionEntity>> getAll() async {
    final rows = await _db.rawQuery('''
      with transactions_tmp as (
        select macc_id, max(tran_created_at), *
        from transactions 
        group by 1
      )
      select macc.macc_id, macc.macc_name, macc.macc_amount, macc.macc_created_at, macc.macc_updated_at,
        macc.macc_order,
        t.tran_id, t.tran_amount, t.tran_description, t.tran_created_at, t.tran_type
      from money_accounts macc
      left join transactions_tmp t on macc.macc_id = t.macc_id
      where macc.macc_deleted_at is null
      order by macc_order asc, macc_created_at desc
    ''');

    return rows.map((e) => MoneyAccountMapper.fromDb(e)).toList();
  }

  @override
  Future<MoneyAccountLastTransactionEntity> getById(String id) async {
    final rows = await _db.rawQuery(
      '''
      with transactions_tmp as (
        select macc_id, max(tran_created_at), *
        from transactions 
        group by 1
      )
      select macc.macc_id, macc.macc_name, macc.macc_amount, macc.macc_created_at, macc.macc_updated_at,
        macc.macc_order,
        t.tran_id, t.tran_amount, t.tran_description, t.tran_created_at, t.tran_type
      from money_accounts macc
      left join transactions_tmp t on macc.macc_id = t.macc_id
      where macc.macc_id = ?
    ''',
      [id],
    );

    if (rows.isEmpty) {
      throw AppException('Money account not found');
    }

    return MoneyAccountMapper.fromDb(rows[0]);
  }

  @override
  Future<bool> update(String id, CreateMoneyAccountEntity entity) async {
    final accountByOrder = await getAccountByOrder(entity.order);

    final accountToUpdate = MoneyAccountEntity(
      id: id,
      name: entity.name,
      amount: entity.value,
      order: entity.order,
      updatedAt: DateTime.now(),
    );

    if (accountByOrder == null) {
      accountToUpdate.order = entity.order;
    } else if (accountByOrder.id != id) {
      final lastOrder = await getLastOrder();

      accountByOrder.order = lastOrder + 1;
      accountByOrder.updatedAt = DateTime.now();

      await _db.update(
        table,
        MoneyAccountMapper.entityToJsonDbUpdate(accountByOrder),
        where: 'macc_id = ?',
        whereArgs: [accountByOrder.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await _db.update(
      table,
      MoneyAccountMapper.entityToJsonDbUpdate(accountToUpdate),
      where: 'macc_id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return true;
  }

  Future<MoneyAccountEntity?> getAccountByOrder(int order) async {
    final account = await _db.query(
      table,
      where: 'macc_order = ? and deleted_at is null',
      whereArgs: [order],
    );

    if (account.isEmpty) return null;

    return MoneyAccountMapper.fromDbToEntity(account[0]);
  }

  Future<int> getLastOrder() async {
    final account = await _db.query(
      table,
      columns: ['macc_order'],
      where: 'macc_deleted_at is null',
      orderBy: 'macc_order DESC',
      limit: 1,
    );

    if (account.isEmpty) return -1;

    return int.parse(account[0]['macc_order'].toString());
  }
}
