import 'package:flutter/widgets.dart';
import 'package:mtg_collection_manager/data/database/entity/mtg_card_db_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao {
  static const databaseName = 'mtg-card-test-db.db';

  static const cardTableName = 'cards';

  @protected
  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        final batch = db.batch();
        _createRecipeTable(batch);
        await batch.commit();
      },
      version: 1,
    );
  }

  void _createRecipeTable(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE $cardTableName(
      ${MtgCardDbEntity.fieldName} TEXT PRIMARY KEY NOT NULL,
      ${MtgCardDbEntity.fieldColors} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldColorIdentity} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldManaCost} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldCmc} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldPower} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldToughness} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldProducedMana} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldTypeLine} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldOracleText} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldRarity} TEXT NOT NULL
      ${MtgCardDbEntity.fieldRulings} TEXT NOT NULL
      ${MtgCardDbEntity.fieldLegalities} TEXT NOT NULL,
      );
      ''',
    );
  }
}
