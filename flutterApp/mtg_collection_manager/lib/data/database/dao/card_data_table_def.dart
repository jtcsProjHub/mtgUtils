import 'package:flutter/widgets.dart';
import 'package:mtg_collection_manager/data/database/entity/mtg_card_db_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class CardDataBaseDao {
  static const databaseName = 'mtg-card-test-db.db';

  static const tableName = 'card_data';

  @protected
  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        final batch = db.batch();
        _createCardStartTable(batch);
        await batch.commit();
      },
      version: 1,
    );
  }

  void _createCardStartTable(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE $tableName(
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
      ${MtgCardDbEntity.fieldRarity} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldRulings} TEXT NOT NULL,
      ${MtgCardDbEntity.fieldLegalStandard} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalFuture} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalHistoric} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalGladiator} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalPioneer} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalExplorer} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalModern} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalLegacy} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalPauper} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalVintage} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalPenny} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalCommander} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalBrawl} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalHistoricBrawl} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalAlchemy} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalPauperCommander} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalDuel} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalOldSchool} INTEGER NOT NULL,
      ${MtgCardDbEntity.fieldLegalPremodern} INTEGER NOT NULL,
      );
      ''',
    );
  }
}
