import 'package:flutter/widgets.dart';
import 'package:mtg_collection_manager/data/database/entity/set_db_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class SetBaseDao {
  static const tableName = 'set_data';

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
      ${SetDbEntity.fieldSetCode} TEXT AS PRIMARY NOT NULL,
      ${SetDbEntity.fieldSetName} INTEGER NOT NULL,
      ${SetDbEntity.fieldScryfallUri} TEXT NOT NULL,
      ${SetDbEntity.fieldReleasedAt} TEXT NOT NULL,
      ${SetDbEntity.fieldIconSvgUri} TEXT NOT NULL,
      ${SetDbEntity.fieldIconSvgLocalPath} TEXT NOT NULL,
      );
      ''',
    );
  }
}
