import 'dart:developer';

import 'package:fit_wallet/features/payments/domain/datasources/datasources.dart';
import 'package:fit_wallet/features/payments/domain/entities/entities.dart';
import 'package:fit_wallet/features/payments/infrastructure/mappers/mappers.dart';
import 'package:sqflite/sqflite.dart';

class PaymentDatasourceDb implements PaymentDatasource {
  PaymentDatasourceDb(this._db);

  final Database _db;

  static const String table = 'payments';

  @override
  Future<bool> create(PaymentEntity entity) async {
    try {
      await _db.insert(table, PaymentMapper.toJsonDb(entity));
      return true;
    } catch (e) {
      log('ERROR DB', error: e);
      return false;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _db.delete(table, where: 'paym_id = ?', whereArgs: [id]);
    } catch (e) {
      log('ERROR DB:', error: e);
    }
  }

  @override
  Future<List<PaymentEntity>> getAll(GetPaymentParams params) async {
    try {
      String orderBy = ' paym.paym_date asc nulls last ';
      // if (params.dateType == DateType.asc) {
      //   orderBy = ' paym.paym_created_at asc ';
      // }

      String whereIsCompleted = '';
      if (params.isCompleted == true) {
        whereIsCompleted = ' where paym.paym_is_completed = 1 ';
      }
      if (params.isCompleted == false) {
        whereIsCompleted = ' where paym.paym_is_completed = 0 ';
      }

      final list = await _db.rawQuery('''
        select paym.paym_id, paym_description, paym_amount, paym_amount_paid, paym_date, paym_is_completed, paym_created_at,
          macc.macc_id, macc.macc_name,
          cate.cate_id, cate.cate_name,
          coalesce( tran.details, 0 ) as paym_has_details
        from payments paym
        left join money_accounts macc on macc.macc_id = paym.macc_id 
        left join categories cate on cate.cate_id = paym.cate_id
        left join ( 
          select paym_id, count(*) details
          from transactions
          where tran_deleted_at = null 
          group by 1 
        ) as tran on tran.paym_id = paym.paym_id
        $whereIsCompleted
        order by $orderBy
     ''');

      return list.map((e) => PaymentMapper.fromJsonDB(e)).toList();
    } catch (e) {
      log('ERROR DB', error: e);
      return [];
    }
  }

  @override
  Future<bool> update(PaymentEntity entity) async {
    final data = PaymentMapper.toJsonDb(entity);
    data.remove('paym_id');

    await _db.update(table, data, where: 'paym_id = ?', whereArgs: [entity.id]);
    return true;
  }

  @override
  Future<PaymentEntity> getById(String id) async {
    final list = await _db.rawQuery(
      '''
        select paym_id, paym_description, paym_amount, paym_amount_paid, paym_date, paym_is_completed, paym_created_at,
          macc.macc_id, macc.macc_name,
          cate.cate_id, cate.cate_name,
          0 paym_has_details
        from payments paym
        left join money_accounts macc on macc.macc_id = paym.macc_id 
        left join categories cate on cate.cate_id = paym.cate_id
        where paym.paym_id = ?
     ''',
      [id],
    );

    return PaymentMapper.fromJsonDB(list[0]);
  }
}
