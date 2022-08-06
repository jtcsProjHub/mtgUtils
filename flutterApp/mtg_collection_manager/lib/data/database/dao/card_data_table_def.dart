import 'package:flutter/widgets.dart';
import 'package:mtg_collection_manager/data/database/entity/card_db_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class CardDataBaseDao {
  static const tableName = 'card_data';

  @protected
  Future<Database> getDatabase({databaseName = 'mtg-card-db.db'}) async {
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
      ${CardDbEntity.fieldName} TEXT PRIMARY KEY NOT NULL,
      ${CardDbEntity.fieldColors} TEXT NOT NULL,
      ${CardDbEntity.fieldColorIdentity} TEXT NOT NULL,
      ${CardDbEntity.fieldManaCost} TEXT NOT NULL,
      ${CardDbEntity.fieldCmc} INTEGER NOT NULL,
      ${CardDbEntity.fieldPower} INTEGER NOT NULL,
      ${CardDbEntity.fieldToughness} INTEGER NOT NULL,
      ${CardDbEntity.fieldProducedMana} TEXT NOT NULL,
      ${CardDbEntity.fieldTypeLine} TEXT NOT NULL,
      ${CardDbEntity.fieldOracleText} TEXT NOT NULL,
      ${CardDbEntity.fieldRarity} TEXT NOT NULL,
      ${CardDbEntity.fieldRulings} TEXT NOT NULL,
      ${CardDbEntity.fieldLegalStandard} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalFuture} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalHistoric} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalGladiator} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalPioneer} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalExplorer} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalModern} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalLegacy} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalPauper} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalVintage} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalPenny} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalCommander} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalBrawl} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalHistoricBrawl} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalAlchemy} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalPauperCommander} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalDuel} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalOldSchool} INTEGER NOT NULL,
      ${CardDbEntity.fieldLegalPremodern} INTEGER NOT NULL,
      );
      ''',
    );
  }
}
