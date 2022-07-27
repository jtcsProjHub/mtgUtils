import 'package:flutter/widgets.dart';
import 'package:mtg_collection_manager/data/database/entity/card_instance_db_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class CardInstanceBaseDao {
  static const databaseName = 'mtg-card-test-db.db';

  static const cardTableName = 'card_instance_data';

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
      CREATE TABLE $cardTableName(
      ${CardInstanceDbEntity.fieldMultiverseId} TEXT PRIMARY KEY NOT NULL,
      ${CardInstanceDbEntity.fieldCardName} TEXT NOT NULL,
      ${CardInstanceDbEntity.fieldSetCode} TEXT NOT NULL,
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
