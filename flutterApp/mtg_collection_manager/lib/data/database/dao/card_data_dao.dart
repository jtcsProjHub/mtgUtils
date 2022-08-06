// lib/data/database/dao/recipe_dao.dart

import 'package:mtg_collection_manager/data/database/dao/card_data_table_def.dart';
import 'package:mtg_collection_manager/data/database/entity/card_db_entity.dart';

class CardDataDao extends CardDataBaseDao {
  Future<List<CardDbEntity>> selectAll() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps =
        await db.query(CardDataBaseDao.tableName);
    return List.generate(maps.length, (i) => CardDbEntity.fromMap(maps[i]));
  }

  Future<void> insertAll(List<CardDbEntity> assets) async {
    final db = await getDatabase();
    final batch = db.batch();

    for (final asset in assets) {
      batch.insert(CardDataBaseDao.tableName, asset.toMap());
    }

    await batch.commit();
  }
}
