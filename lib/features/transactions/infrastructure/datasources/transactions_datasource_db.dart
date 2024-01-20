import 'dart:developer';

import 'package:fit_wallet/features/shared/domain/domain.dart';
import 'package:fit_wallet/features/shared/infrastructure/infrastructure.dart';
import 'package:fit_wallet/features/transactions/domain/domain.dart';
import 'package:fit_wallet/features/transactions/infrastructure/mappers/mappers.dart';
import 'package:sqflite/sqflite.dart';

class TransactionsDatasourceDb implements TransactionsDatasource {
  TransactionsDatasourceDb(this._db);

  final Database _db;

  static const String table = 'transactions';

  @override
  Future<void> create(CreateTransactionEntity entity) async {
    final transaction = TransactionsMapper.createToJsonDb(entity);

    transaction['tran_id'] = Utils.uuid;
    transaction['tran_created_at'] = Utils.now;

    await _db.insert(table, transaction);

    double value = entity.amount;

    if (entity.type == TransactionType.expense ||
        entity.type == TransactionType.transfer) {
      value *= -1;
    }

    await _db.rawUpdate(
      '''
      update money_accounts set macc_amount = ( macc_amount + ? )
      where macc_id = ?
      ''',
      [value, entity.maccId],
    );

    if (entity.type == TransactionType.transfer) {
      await _db.rawUpdate(
        '''
      update money_accounts set macc_amount = ( macc_amount + ? )
      where macc_id = ?
      ''',
        [value * -1, entity.maccIdTransfer],
      );
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      final transaction = await _db.query(
        table,
        columns: [
          'tran_amount',
          'tran_type',
          'macc_id',
          'macc_id_transfer',
          'paym_id'
        ],
        where: 'tran_id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (transaction.isEmpty) return true;

      double value = double.parse(transaction.first['tran_amount'].toString());

      if (TransactionTypeMapper.fromString(
              transaction.first['tran_type'].toString()) ==
          TransactionType.income) {
        value *= -1;
      }

      await _db.update(
        table,
        {'tran_deleted_at': Utils.now},
        where: 'tran_id = ?',
        whereArgs: [id],
      );

      final maccId = transaction.first['macc_id'];

      await _db.rawUpdate(
        '''
          update money_accounts set macc_amount = ( macc_amount + ? )
          where macc_id = ?
        ''',
        [value, maccId],
      );

      final maccIdTransfer = transaction.first['macc_id_transfer'];

      if (maccIdTransfer != null) {
        await _db.rawUpdate(
          '''
          update money_accounts set macc_amount = ( macc_amount + ? )
          where macc_id = ?
        ''',
          [value * -1, maccIdTransfer],
        );
      }

      final paymId = transaction.first['paym_id'];

      if (paymId != null) {
        await _db.rawUpdate(
          'update payments set paym_amount_paid = paym_amount_paid - ? where paym_id = ? ',
          [value, paymId],
        );
      }
    } catch (e) {
      log('ERROR delete transaction', error: e);
      return false;
    }

    return true;
  }

  @override
  Future<PaginationEntity<TransactionEntity>> getAll(
    GetTransactionsParams params,
  ) async {
    String andTypeIs = '';
    if (params.type != TransactionTypeFilter.all) {
      andTypeIs = " and tran_type = '${params.type.name.toUpperCase()}' ";
    }

    String andDateIs = '';
    if (params.date != null) {
      final start = DateTime(
          params.date!.year, params.date!.month, params.date!.day, 0, 0, 0);
      final end = DateTime(
          params.date!.year, params.date!.month, params.date!.day, 23, 59, 59);

      andDateIs =
          " and tran_created_at between ${Utils.unix(start)} and ${Utils.unix(end)}";
    }

    String andStartDateIs = '';
    if (params.startDate != null) {
      andStartDateIs =
          " and tran_created_at >= ${Utils.unix(params.startDate!)} ";
    }

    String andEndDateIs = '';
    if (params.endDate != null) {
      andEndDateIs = " and tran_created_at <= ${Utils.unix(params.endDate!)} ";
    }

    String andMaccIdIs = '';
    if (params.maccId != null) {
      andMaccIdIs =
          " and ( tran.macc_id = '${params.maccId}' or tran.macc_id_transfer = '${params.maccId}' ) ";
    }

    String andPaymIdIs = '';
    if (params.paymId != null) {
      andPaymIdIs = " and tran.paym_id = '${params.paymId}' ";
    }

    final offset = params.page * params.limit - params.limit;

    final locale = Utils.locale.split('_')[0];

    final query = await _db.rawQuery(
      '''
      select tran_id, tran_description, tran_amount, tran_type, tran_created_at, 
        macc.macc_id, macc.macc_name, 
        macc_transfer.macc_id as macc_id_transfer, macc_transfer.macc_name as macc_name_transfer, 
        cate.cate_id,  
        case when ? = 'es' then term.term_text else cate.cate_name end as cate_name,
         cate_icon, cate_hex_color
      from transactions tran
      left join money_accounts macc on macc.macc_id = tran.macc_id 
      left join money_accounts macc_transfer on macc_transfer.macc_id = tran.macc_id_transfer 
      left join categories cate on cate.cate_id = tran.cate_id
      left join terms term on term.reg_id = cate.cate_id 
      where tran.tran_deleted_at is null
        $andTypeIs $andDateIs $andStartDateIs $andEndDateIs $andMaccIdIs $andPaymIdIs
      order by tran_created_at desc
      limit ?
      offset ?
      ''',
      [locale, params.limit, offset],
    );

    final total = Sqflite.firstIntValue(
      await _db.rawQuery('''
      select count(*)
      from transactions tran
      left join money_accounts macc on macc.macc_id = tran.macc_id 
      left join categories cate on cate.cate_id = tran.cate_id
      where tran.tran_deleted_at is null $andTypeIs $andDateIs $andStartDateIs $andEndDateIs $andMaccIdIs $andPaymIdIs
      order by tran_created_at desc
    '''),
    );

    final totalPages = ((total ?? 0) / params.limit).ceil();
    final nextPage = (params.page >= totalPages) ? null : (params.page + 1);

    final transactions =
        query.map((e) => TransactionsMapper.fromJsonDb(e)).toList();

    return PaginationEntity(
      items: transactions,
      page: params.page,
      totalItems: transactions.length,
      totalPages: totalPages,
      nextPage: nextPage,
      total: total ?? 0,
    );
  }

  @override
  Future<BalanceEntity> getBalance(BalanceParams params) async {
    String andDateBetween = '';

    if (params.startDate != null && params.endDate != null) {
      andDateBetween =
          " and tran_created_at between ${Utils.unix(params.startDate!)} and ${Utils.unix(params.endDate!)}";
    }

    String andDateIs = '';

    if (params.date != null) {
      final start = DateTime(
          params.date!.year, params.date!.month, params.date!.day, 0, 0, 0);
      final end = DateTime(
          params.date!.year, params.date!.month, params.date!.day, 23, 59, 59);

      andDateIs =
          " and tran_created_at between ${Utils.unix(start)} and ${Utils.unix(end)}";
    }

    final query = await _db.rawQuery(
      '''
      with data as (
        select tran.tran_type as type, sum( tran.tran_amount ) as value
        from transactions tran
        join money_accounts macc on macc.macc_id = tran.macc_id and macc.macc_deleted_at is null
        where tran.tran_deleted_at is null $andDateBetween $andDateIs
        group by 1
      )
      select type, value from data
    ''',
    );

    if (query.isEmpty) {
      return BalanceEntity(
        incomes: BalanceDetail(0),
        expenses: BalanceDetail(0),
        balance: BalanceDetail(0),
      );
    }

    final rawIncomes = query
        .firstWhere((element) => element['type'] == 'INCOME', orElse: () => {});

    BalanceDetail incomes;
    if (rawIncomes.isEmpty) {
      incomes = BalanceDetail(0);
    } else {
      incomes = BalanceDetail.fromJson(rawIncomes);
    }

    final rawExpenses = query.firstWhere(
        (element) => element['type'] == 'EXPENSE',
        orElse: () => {});
    BalanceDetail expenses;
    if (rawExpenses.isEmpty) {
      expenses = BalanceDetail(0);
    } else {
      expenses = BalanceDetail.fromJson(rawExpenses);
    }

    final balance = BalanceDetail(incomes.value - expenses.value);

    return BalanceEntity(
      incomes: incomes,
      expenses: expenses,
      balance: balance,
    );
  }

  @override
  Future<TransactionEntity> getById(String id) async {
    final query = await _db.rawQuery(
      '''
      select tran_id, tran_description, tran_amount, tran_type, tran_created_at, 
        macc.macc_id, macc_name, 
        cate.cate_id, cate_name, cate_icon, cate_hex_color
      from transactions tran
      left join money_accounts macc on macc.macc_id = tran.macc_id 
      left join categories cate on cate.cate_id = tran.cate_id
      where tran.tran_id = ?
    ''',
      [id],
    );

    return TransactionsMapper.fromJsonDb(query.first);
  }
}
