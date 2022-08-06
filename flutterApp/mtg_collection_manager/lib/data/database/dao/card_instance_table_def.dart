import 'package:flutter/widgets.dart';
import 'package:mtg_collection_manager/data/database/dao/card_data_table_def.dart';
import 'package:mtg_collection_manager/data/database/dao/set_table_def.dart';
import 'package:mtg_collection_manager/data/database/entity/card_instance_db_entity.dart';
import 'package:mtg_collection_manager/data/database/entity/card_db_entity.dart';
import 'package:mtg_collection_manager/data/database/entity/set_db_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class CardInstanceBaseDao {
  static const tableName = 'card_instance_data';

  @protected
  Future<Database> getDatabase({databaseName = 'mtg-card-db.db'}) async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        final batch = db.batch();
        _createCardStartTable(batch);
        await batch.commit();
      },
      onConfigure: _onConfigure,
      version: 1,
    );
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  void _createCardStartTable(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE $tableName(
      ${CardInstanceDbEntity.fieldMultiverseId} TEXT PRIMARY KEY NOT NULL,
      FOREIGN KEY(${CardInstanceDbEntity.fieldCardName}) REFERENCES ${CardDataBaseDao.tableName}(${CardDbEntity.fieldName}) TEXT NOT NULL,
      FOREIGN KEY(${CardInstanceDbEntity.fieldSetCode}) REFERENCES ${SetBaseDao.tableName}(${SetDbEntity.fieldSetCode}) TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldQuantity} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldReleasedAt} INTEGER NOT NULL,
      ${CardInstanceDbEntity.fieldImageUriSmall} INTEGER NOT NULL,
      ${CardInstanceDbEntity.fieldImageUriNormal} INTEGER NOT NULL,
      ${CardInstanceDbEntity.fieldImageUriLarge} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageUriPng} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageUriArtCrop} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageUriBorderCrop} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageLocalSmall} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageLocalNormal} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageLocalLarge} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageLocalPng} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageLocalArtCrop} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldImageLocalBorderCrop} TEXT NOT NULL,
      );
      ''',
    );
  }
}
